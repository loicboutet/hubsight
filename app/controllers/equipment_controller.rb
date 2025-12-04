class EquipmentController < ApplicationController
  before_action :require_organization_or_admin
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :set_space, only: [:new, :create], if: -> { params[:space_id].present? }
  before_action :load_organizations_for_admin, only: [:new, :edit], if: -> { current_user&.admin? }
  
  def index
    # Get base query - admins see all, others see only their organization
    if current_user.admin?
      @equipment = Equipment.all
    else
      @equipment = current_organization.equipment
    end
    
    # Apply filters
    @equipment = apply_filters(@equipment)
    
    # Apply sorting
    @equipment = apply_sorting(@equipment)
    
    # Get count before pagination
    @all_equipment_count = @equipment.count
    
    # Apply pagination
    @per_page = (params[:per_page] || 15).to_i
    @equipment = @equipment.includes(space: { level: { building: :site } })
                           .page(params[:page]).per(@per_page)
    
    # Store filter values for the view
    @filter_params = {
      search: params[:search],
      organization: params[:organization],
      site: params[:site],
      building: params[:building],
      equipment_type: params[:equipment_type],
      status: params[:status],
      criticality: params[:criticality]
    }
    
    # Get unique values for filter dropdowns
    if current_user.admin?
      @organizations = Organization.order(:name)
      @sites = Site.order(:name)
      @buildings = Building.order(:name)
    else
      @sites = Site.by_organization(current_user.organization_id).order(:name)
      @buildings = Building.by_organization(current_user.organization_id).order(:name)
    end
    @equipment_types = EquipmentType.order(:equipment_type_name)
    
    # Store sorting params
    @sort_column = params[:sort] || 'name'
    @sort_direction = params[:direction] || 'asc'
  end

  def show
    # @equipment is set by before_action
  end

  def new
    @equipment = Equipment.new
    @equipment.space_id = params[:space_id] if params[:space_id].present?
    @equipment.organization_id = params[:organization_id] if params[:organization_id].present?
  end

  def create
    @equipment = Equipment.new(equipment_params)
    
    # Set organization_id: from params (admin), current_organization, or fail
    if current_user.admin? && params[:equipment][:organization_id].present?
      @equipment.organization_id = params[:equipment][:organization_id]
    elsif current_organization
      @equipment.organization_id = current_organization.id
    else
      load_organizations_for_admin if current_user.admin?
      flash.now[:alert] = 'Vous devez sélectionner une organisation.'
      render :new, status: :unprocessable_entity
      return
    end
    
    @equipment.created_by_name = current_user.full_name
    
    # If space_id is provided, the model callback will set hierarchy
    if @equipment.save
      redirect_to @equipment, notice: 'Équipement créé avec succès.'
    else
      load_organizations_for_admin if current_user.admin?
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @equipment is set by before_action
  end

  def update
    @equipment.updated_by_name = current_user.full_name
    
    if @equipment.update(equipment_params)
      redirect_to @equipment, notice: 'Équipement mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Validate password for JSON requests (from modal)
    if request.format.json?
      password = params[:password]
      unless current_user.valid_password?(password)
        render json: { 
          success: false, 
          error: 'Mot de passe incorrect. Veuillez réessayer.' 
        }, status: :unauthorized
        return
      end
    end
    
    space = @equipment.space
    equipment_name = @equipment.name
    equipment_id = @equipment.id
    organization_id = @equipment.organization_id
    
    @equipment.destroy
    
    # Log the deletion in audit trail
    AuditLog.log_action(
      user: current_user,
      action: 'delete',
      auditable_type: 'Equipment',
      auditable_id: equipment_id,
      change_data: { name: equipment_name },
      metadata: { 
        organization_id: organization_id,
        space_id: space&.id,
        deleted_at: Time.current.iso8601
      },
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      status: 'success'
    )
    
    respond_to do |format|
      format.html do
        redirect_to space ? space_path(space) : equipment_index_path, 
                    notice: 'Équipement supprimé avec succès.'
      end
      format.json do
        redirect_url = space ? space_path(space) : equipment_index_path
        render json: { 
          success: true, 
          redirect_url: redirect_url,
          message: 'Équipement supprimé avec succès.'
        }
      end
    end
  end

  def search
    # Renders equipment/search.html.erb
  end

  private
  
  def apply_filters(equipment)
    # Search filter (name, serial number, manufacturer, model)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      equipment = equipment.where(
        "name LIKE ? OR serial_number LIKE ? OR manufacturer LIKE ? OR model LIKE ?",
        search_term, search_term, search_term, search_term
      )
    end
    
    # Organization filter (admin only)
    if params[:organization].present? && current_user.admin?
      equipment = equipment.where(organization_id: params[:organization])
    end
    
    # Site filter
    if params[:site].present?
      equipment = equipment.where(site_id: params[:site])
    end
    
    # Building filter
    if params[:building].present?
      equipment = equipment.where(building_id: params[:building])
    end
    
    # Equipment type filter
    if params[:equipment_type].present?
      equipment = equipment.where(equipment_type_id: params[:equipment_type])
    end
    
    # Status filter
    if params[:status].present?
      equipment = equipment.where(status: params[:status])
    end
    
    # Criticality filter
    if params[:criticality].present?
      equipment = equipment.where(criticality: params[:criticality])
    end
    
    equipment
  end
  
  def apply_sorting(equipment)
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    
    # Validate sort column to prevent SQL injection
    allowed_columns = %w[
      name equipment_type manufacturer model serial_number
      status criticality manufacturing_date commissioning_date
      warranty_end_date created_at updated_at
    ]
    
    if allowed_columns.include?(sort_column)
      # Handle NULL values for date columns
      if ['manufacturing_date', 'commissioning_date', 'warranty_end_date'].include?(sort_column)
        equipment = equipment.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_direction}"))
      else
        equipment = equipment.order("#{sort_column} #{sort_direction}")
      end
    else
      # Default sort
      equipment = equipment.order(name: :asc)
    end
    
    equipment
  end

  def require_organization_or_admin
    # Allow admins to proceed (they can select organization in form)
    return if current_user&.admin?
    
    # For regular users, require organization
    unless current_organization
      redirect_to root_path, alert: 'Vous devez être associé à une organisation pour accéder aux équipements.'
    end
  end

  def load_organizations_for_admin
    @organizations = Organization.order(:name) if current_user&.admin?
  end

  def set_equipment
    @equipment = if current_user.admin?
                   Equipment.includes(space: { level: { building: :site } }).find(params[:id])
                 else
                   current_organization.equipment.includes(space: { level: { building: :site } }).find(params[:id])
                 end
  rescue ActiveRecord::RecordNotFound
    redirect_to equipment_index_path, alert: 'Équipement non trouvé.'
  end
  
  def set_space
    @space = if current_user.admin?
               Space.includes(level: { building: :site }).find(params[:space_id])
             else
               current_organization.spaces.includes(level: { building: :site }).find(params[:space_id])
             end
  rescue ActiveRecord::RecordNotFound
    redirect_to spaces_path, alert: 'Espace non trouvé.'
  end

  def equipment_params
    permitted = [
      :space_id,
      :name,
      :equipment_type,
      :equipment_type_id,
      :equipment_category,
      :manufacturer,
      :model,
      :serial_number,
      :bdd_reference,
      :nominal_power,
      :nominal_voltage,
      :current,
      :frequency,
      :weight,
      :dimensions,
      :manufacturing_date,
      :commissioning_date,
      :warranty_end_date,
      :next_maintenance_date,
      :supplier,
      :purchase_price,
      :order_number,
      :invoice_number,
      :status,
      :criticality,
      :notes
    ]
    
    # Allow organization_id for admins
    permitted << :organization_id if current_user&.admin?
    
    params.require(:equipment).permit(permitted)
  end
end
