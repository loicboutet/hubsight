class SiteManager::EquipmentController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :authenticate_user!
  before_action :ensure_site_manager_role
  before_action :set_equipment, only: [:show]
  
  def index
    # Get all equipment from assigned sites
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    
    @equipment = Equipment.where(site_id: assigned_site_ids)
                         .where(organization_id: current_user.organization_id)
                         .includes(:site, :building, :level, :space, :equipment_type)
                         .order('sites.name ASC, buildings.name ASC, levels.level_number ASC, spaces.name ASC, equipment.name ASC')
    
    # Apply filters
    @equipment = apply_filters(@equipment)
    
    # Search
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @equipment = @equipment.where(
        "equipment.name LIKE ? OR equipment.manufacturer LIKE ? OR equipment.model LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Statistics (calculate before pagination)
    @total_count = @equipment.count
    @active_count = @equipment.where(status: 'active').count
    @maintenance_count = @equipment.where(status: 'maintenance').count
    @critical_count = @equipment.where(criticality: 'critical').count
    
    # Pagination
    @equipment = @equipment.page(params[:page]).per(25)
    
    # Get assigned sites for filter dropdown
    @assigned_sites = current_user.assigned_sites.order(:name)
    
    # Check if site manager has any assigned sites
    unless has_assigned_sites?
      flash.now[:alert] = "Aucun site ne vous a été assigné. Vous ne pouvez pas voir d'équipements."
    end
  end
  
  def show
    # Equipment details are loaded in before_action
    # This is a read-only view
  end
  
  private
  
  def ensure_site_manager_role
    unless current_user.site_manager?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
  def set_equipment
    # Only allow access to equipment from assigned sites
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    @equipment = Equipment.where(site_id: assigned_site_ids)
                         .where(organization_id: current_user.organization_id)
                         .includes(:site, :building, :level, :space, :equipment_type)
                         .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_equipment_index_path, alert: "Vous n'avez pas accès à cet équipement."
  end
  
  def apply_filters(equipment)
    equipment = equipment.where(site_id: params[:site_id]) if params[:site_id].present?
    equipment = equipment.where(building_id: params[:building_id]) if params[:building_id].present?
    equipment = equipment.where(level_id: params[:level_id]) if params[:level_id].present?
    equipment = equipment.where(space_id: params[:space_id]) if params[:space_id].present?
    equipment = equipment.where(status: params[:status]) if params[:status].present?
    equipment = equipment.where(criticality: params[:criticality]) if params[:criticality].present?
    equipment = equipment.where(equipment_type_id: params[:equipment_type_id]) if params[:equipment_type_id].present?
    equipment
  end
end
