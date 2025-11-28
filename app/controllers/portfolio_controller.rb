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
    @organization = current_user.organization
    
    unless @organization
      flash[:alert] = "Aucune organisation associée à votre compte."
      redirect_to root_path
    end
  end
end
