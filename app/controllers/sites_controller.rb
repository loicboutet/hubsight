class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :authorize_portfolio_manager, except: [:index, :show]
  
  def index
    # Admin sees all sites, other users see only their organization's sites
    if current_user.admin?
      @sites = Site.all
    else
      @sites = current_user.sites
    end
    
    # Apply filters BEFORE pagination
    if params[:search].present?
      # Search in both name and city (OR condition)
      search_term = "%#{params[:search]}%"
      @sites = @sites.where("name LIKE ? OR city LIKE ?", search_term, search_term)
    end
    @sites = @sites.by_type(params[:site_type]) if params[:site_type].present?
    @sites = @sites.by_region(params[:region]) if params[:region].present?
    
    # Apply sorting BEFORE pagination
    case params[:sort_by]
    when 'area'
      @sites = @sites.order(total_area: :desc)
    when 'buildings_count'
      @sites = @sites.left_joins(:buildings).group('sites.id').order('COUNT(buildings.id) DESC')
    else
      @sites = @sites.ordered_by_name
    end
    
    # Apply eager loading and pagination LAST
    @sites = @sites.includes(:buildings)
                   .page(params[:page])
                   .per(10)
  end

  def show
    # Calculate real statistics from database
    @buildings_count = @site.buildings.count
    @levels_count = @site.levels.count
    @spaces_count = Space.joins(level: :building).where(buildings: { site_id: @site.id }).count
    @equipment_count = Equipment.joins(space: { level: :building }).where(buildings: { site_id: @site.id }).count
    
    # Get actual contacts associated with this site
    # For now, use site manager info as primary contact
    @contacts = []
    if @site.site_manager.present? || @site.contact_email.present? || @site.contact_phone.present?
      @contacts << {
        name: @site.site_manager || "Non renseigné",
        role: "Responsable de Site",
        phone: @site.contact_phone || "Non renseigné",
        email: @site.contact_email || "Non renseigné",
        organization: @site.name
      }
    end
  end

  def new
    @site = current_user.sites.build(status: 'active', country: 'France')
  end

  def create
    @site = current_user.sites.build(site_params)
    
    if @site.save
      redirect_to sites_path, notice: "Site créé avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to site_path(@site), notice: "Site mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Verify password for critical deletion
    unless verify_password_for_deletion
      redirect_to sites_path, alert: "Mot de passe incorrect. La suppression a été annulée."
      return
    end

    # Check dependencies
    dependency_check = check_site_dependencies
    unless dependency_check[:can_delete]
      redirect_to sites_path, alert: dependency_check[:message]
      return
    end

    # Capture site data before deletion for audit log
    site_data = {
      name: @site.name,
      code: @site.code,
      city: @site.city,
      site_type: @site.site_type,
      buildings_count: @site.buildings.count,
      total_area: @site.total_area
    }

    # Perform deletion in a transaction
    ActiveRecord::Base.transaction do
      # Log the deletion attempt
      AuditLog.log_action(
        user: current_user,
        action: 'delete',
        auditable_type: 'Site',
        auditable_id: @site.id,
        change_data: site_data,
        metadata: {
          confirmed: true,
          password_verified: true,
          dependencies_checked: true
        },
        ip_address: request.remote_ip,
        user_agent: request.user_agent
      )

      # Destroy the site
      if @site.destroy
        redirect_to sites_path, notice: "Site '#{site_data[:name]}' supprimé avec succès. Cette action a été enregistrée dans l'audit trail."
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback
    # Log failed deletion
    AuditLog.log_action(
      user: current_user,
      action: 'delete',
      auditable_type: 'Site',
      auditable_id: @site.id,
      change_data: site_data,
      metadata: { confirmed: true, password_verified: true },
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      status: 'failed',
      error_message: @site.errors.full_messages.join(', ')
    )
    
    redirect_to sites_path, alert: "Impossible de supprimer le site: #{@site.errors.full_messages.join(', ')}"
  rescue StandardError => e
    # Log unexpected errors
    AuditLog.log_action(
      user: current_user,
      action: 'delete',
      auditable_type: 'Site',
      auditable_id: @site&.id,
      change_data: site_data || {},
      metadata: { confirmed: true },
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      status: 'failed',
      error_message: e.message
    )
    
    redirect_to sites_path, alert: "Une erreur est survenue lors de la suppression: #{e.message}"
  end
  
  private
  
  def set_site
    # Admin can access all sites, other users can only access their organization's sites
    if current_user.admin?
      @site = Site.find(params[:id])
    else
      @site = current_user.sites.find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to sites_path, alert: "Site introuvable"
  end
  
  def authorize_portfolio_manager
    unless current_user.admin? || current_user.portfolio_manager?
      redirect_to sites_path, alert: "Vous n'avez pas l'autorisation d'effectuer cette action"
    end
  end
  
  def site_params
    params.require(:site).permit(
      :name,
      :code,
      :site_type,
      :status,
      :description,
      :address,
      :city,
      :postal_code,
      :department,
      :region,
      :country,
      :total_area,
      :estimated_area,
      :site_manager,
      :contact_email,
      :contact_phone,
      :gps_coordinates,
      :climate_zone,
      :cadastral_id,
      :rnb_id
    )
  end

  # Verify user password for critical deletions
  def verify_password_for_deletion
    password = params[:password] || params.dig(:site, :password)
    return false unless password.present?
    
    current_user.valid_password?(password)
  end

  # Check for dependencies before deletion
  def check_site_dependencies
    buildings_count = @site.buildings.count
    
    # Count equipment through buildings -> levels -> spaces -> equipment
    equipment_count = Equipment.joins(space: { level: :building })
                               .where(buildings: { site_id: @site.id })
                               .count
    
    contracts_count = Contract.where(site_id: @site.id).count
    
    # Count total items that will be deleted
    total_dependencies = buildings_count + equipment_count + contracts_count
    
    if total_dependencies > 0
      message = "Ce site ne peut pas être supprimé car il contient : "
      parts = []
      parts << "#{buildings_count} bâtiment(s)" if buildings_count > 0
      parts << "#{equipment_count} équipement(s)" if equipment_count > 0
      parts << "#{contracts_count} contrat(s)" if contracts_count > 0
      message += parts.join(", ")
      message += ". Veuillez d'abord supprimer ces éléments ou les réassigner."
      
      {
        can_delete: false,
        message: message,
        buildings_count: buildings_count,
        equipment_count: equipment_count,
        contracts_count: contracts_count
      }
    else
      {
        can_delete: true,
        message: "Aucune dépendance trouvée"
      }
    end
  end
end
