class LevelsController < ApplicationController
  before_action :set_building, only: [:index, :new, :create]
  before_action :set_level, only: [:show, :edit, :update, :destroy]

  def index
    @levels = @building.levels.ordered
  end

  def show
    @building = @level.building
    @site = @building.site
    
    # Calculate equipment count for this level
    @equipment_count = Equipment.joins(:space).where(spaces: { level_id: @level.id }).count
  end

  def new
    @level = @building.levels.build(
      organization_id: @building.organization_id
    )
  end

  def create
    @level = @building.levels.build(level_params)
    @level.organization_id = @building.organization_id
    @level.created_by_name = current_user.full_name

    if @level.save
      redirect_to building_path(@building), notice: "Niveau créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @building = @level.building
  end

  def update
    @level.updated_by_name = current_user.full_name

    if @level.update(level_params)
      redirect_to building_path(@level.building), notice: "Niveau mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    building = @level.building
    @level.destroy
    redirect_to building_path(building), notice: "Niveau supprimé avec succès."
  end

  private

  def set_building
    @building = Building.find(params[:building_id])
    # Ensure user has access to this building's organization
    # Admins can access all buildings across all organizations
    unless current_user.admin? || @building.organization_id == current_user.organization_id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def set_level
    @level = Level.find(params[:id])
    # Ensure user has access to this level's organization
    # Admins can access all levels across all organizations
    unless current_user.admin? || @level.organization_id == current_user.organization_id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def level_params
    params.require(:level).permit(
      :name,
      :level_number,
      :altitude,
      :area,
      :description
    )
  end
end
