class EquipmentController < ApplicationController
  before_action :require_organization_or_admin
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :set_space, only: [:new, :create], if: -> { params[:space_id].present? }
  before_action :load_organizations_for_admin, only: [:new, :edit], if: -> { current_user&.admin? }
  
  def index
    @equipment = if current_user.admin? && params[:organization_id].present?
                   Organization.find(params[:organization_id]).equipment
                 elsif current_organization
                   current_organization.equipment
                 else
                   Equipment.none
                 end
    
    @equipment = @equipment.includes(space: { level: { building: :site } })
                           .order(created_at: :desc)
                           .page(params[:page]).per(10)
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
    space = @equipment.space
    @equipment.destroy
    
    redirect_to space ? space_path(space) : equipment_index_path, 
                notice: 'Équipement supprimé avec succès.'
  end

  def search
    # Renders equipment/search.html.erb
  end

  private

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
               Space.find(params[:space_id])
             else
               current_organization.spaces.find(params[:space_id])
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
