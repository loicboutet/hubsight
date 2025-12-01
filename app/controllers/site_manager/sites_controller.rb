class SiteManager::SitesController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :authenticate_user!
  before_action :ensure_site_manager_role
  before_action :set_site, only: [:show, :equipment]
  
  def index
    @sites = current_user.assigned_sites
                        .includes(:buildings)
                        .order(:name)
                        .page(params[:page])
                        .per(10)
    
    # Check if site manager has any assigned sites
    unless has_assigned_sites?
      flash.now[:alert] = "Aucun site ne vous a été assigné. Veuillez contacter votre gestionnaire de portefeuille."
    end
  end

  def show
    @opening_hours = [
      { day: "Lundi", open: true, from: "08:00", to: "20:00" },
      { day: "Mardi", open: true, from: "08:00", to: "20:00" },
      { day: "Mercredi", open: true, from: "08:00", to: "20:00" },
      { day: "Jeudi", open: true, from: "08:00", to: "20:00" },
      { day: "Vendredi", open: true, from: "08:00", to: "20:00" },
      { day: "Samedi", open: true, from: "09:00", to: "21:00" },
      { day: "Dimanche", open: true, from: "10:00", to: "19:00" },
      { day: "Jours fériés", open: false, from: "Fermé", to: "Fermé" }
    ]
    
    @contacts = [
      {
        name: @site.site_manager || "N/A",
        role: "Responsable de Site",
        phone: @site.contact_phone || "N/A",
        email: @site.contact_email || "N/A",
        organization: @site.name
      }
    ]
  end

  def equipment
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    
    @equipment = Equipment.where(site_id: @site.id)
                         .where(organization_id: current_user.organization_id)
                         .includes(:building, :level, :space, :equipment_type)
                         .order('buildings.name ASC, levels.level_number ASC, spaces.name ASC, equipment.name ASC')
    
    # Apply filters
    @equipment = apply_site_equipment_filters(@equipment)
    
    # Search
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @equipment = @equipment.where(
        "equipment.name LIKE ? OR equipment.manufacturer LIKE ? OR equipment.model LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Statistics for this site
    @total_count = @equipment.count
    @active_count = @equipment.where(status: 'active').count
    @maintenance_count = @equipment.where(status: 'maintenance').count
    @critical_count = @equipment.where(criticality: 'critical').count
    
    # Hierarchical grouping for tree view
    @equipment_by_building = @equipment.group_by(&:building)
    
    # Pagination
    @equipment = @equipment.page(params[:page]).per(15)
    
    # Get buildings/levels/spaces for filters
    @buildings = @site.buildings.order(:name)
  end
  
  private
  
  def ensure_site_manager_role
    unless current_user.site_manager?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
  def set_site
    @site = current_user.assigned_sites.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_sites_path, alert: "Vous n'avez pas accès à ce site."
  end
  
  def apply_site_equipment_filters(equipment)
    equipment = equipment.where(building_id: params[:building_id]) if params[:building_id].present?
    equipment = equipment.where(level_id: params[:level_id]) if params[:level_id].present?
    equipment = equipment.where(space_id: params[:space_id]) if params[:space_id].present?
    equipment = equipment.where(status: params[:status]) if params[:status].present?
    equipment = equipment.where(equipment_type_id: params[:equipment_type_id]) if params[:equipment_type_id].present?
    equipment
  end
end
