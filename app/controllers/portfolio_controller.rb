class PortfolioController < ApplicationController
  before_action :authenticate_user!
  before_action :set_organization
  
  def index
    # Load entire hierarchy for current organization with eager loading to avoid N+1 queries
    @sites = @organization.sites
      .includes(buildings: { levels: { spaces: :equipment } })
      .ordered_by_name
    
    # Statistics for overview
    @total_sites = @sites.count
    @total_buildings = @organization.buildings.count
    @total_levels = @organization.levels.count
    @total_spaces = @organization.spaces.count
    @total_equipment = @organization.equipment.count
  end
  
  private
  
  def set_organization
    # Admin users can view all data across all organizations
    if current_user.admin?
      # For now, admins see aggregated view across all organizations
      # You can later add organization selection for admins
      @organization = Organization.new # Virtual organization for admin view
      @organization.readonly!
      
      # Override association methods to return all records
      @organization.define_singleton_method(:sites) { Site.all }
      @organization.define_singleton_method(:buildings) { Building.all }
      @organization.define_singleton_method(:levels) { Level.all }
      @organization.define_singleton_method(:spaces) { Space.all }
      @organization.define_singleton_method(:equipment) { Equipment.all }
    else
      # Regular users see only their organization's data
      @organization = current_user.organization
      
      unless @organization
        flash[:alert] = "Aucune organisation associée à votre compte."
        redirect_to root_path
      end
    end
  end
end
