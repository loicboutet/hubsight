class EquipmentController < ApplicationController
  before_action :set_equipment, only: [:show, :edit, :update, :destroy]
  before_action :set_space, only: [:new, :create], if: -> { params[:space_id].present? }
  
  def index
    @equipment = current_user.organization.equipment
                             .includes(space: { level: { building: :site } })
                             .order(created_at: :desc)
                             .page(params[:page]).per(10)
  end

  def show
    # @equipment is set by before_action
  end

  def new
    @equipment = Equipment.new
    @equipment.space_id = params[:space_id] if params[:space_id].present?
  end

  def create
    @equipment = Equipment.new(equipment_params)
    @equipment.organization_id = current_user.organization_id
    @equipment.created_by_name = current_user.full_name
    
    # If space_id is provided, the model callback will set hierarchy
    if @equipment.save
      redirect_to @equipment, notice: 'Équipement créé avec succès.'
    else
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

  def set_equipment
    @equipment = current_user.organization.equipment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to equipment_index_path, alert: 'Équipement non trouvé.'
  end
  
  def set_space
    @space = current_user.organization.spaces.find(params[:space_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to spaces_path, alert: 'Espace non trouvé.'
  end

  def equipment_params
    params.require(:equipment).permit(
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
    )
  end
end
