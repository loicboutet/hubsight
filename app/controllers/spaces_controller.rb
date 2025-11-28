class SpacesController < ApplicationController
  before_action :set_level, only: [:index, :new, :create]
  before_action :set_space, only: [:show, :edit, :update, :destroy]

  def index
    @spaces = @level.spaces.ordered
  end

  def show
    @level = @space.level
    @building = @level.building
    @site = @building.site
  end

  def new
    @space = @level.spaces.build(
      organization_id: current_user.organization_id
    )
  end

  def create
    @space = @level.spaces.build(space_params)
    @space.organization_id = current_user.organization_id
    @space.created_by_name = current_user.full_name

    if @space.save
      redirect_to level_path(@level), notice: "Espace créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @level = @space.level
  end

  def update
    @space.updated_by_name = current_user.full_name

    if @space.update(space_params)
      redirect_to level_path(@space.level), notice: "Espace mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    level = @space.level
    @space.destroy
    redirect_to level_path(level), notice: "Espace supprimé avec succès."
  end

  private

  def set_level
    @level = Level.find(params[:level_id])
    # Ensure user has access to this level's organization
    unless @level.organization_id == current_user.organization_id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def set_space
    @space = Space.find(params[:id])
    # Ensure user has access to this space's organization
    unless @space.organization_id == current_user.organization_id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def space_params
    params.require(:space).permit(
      :name,
      :space_type,
      :area,
      :ceiling_height,
      :capacity,
      :primary_use,
      :secondary_use,
      :floor_covering,
      :wall_covering,
      :ceiling_type,
      :present_equipment,
      :water_points,
      :electrical_outlets,
      :network_connectivity,
      :natural_lighting,
      :ventilation,
      :heating,
      :air_conditioning,
      :pmr_accessibility,
      :has_windows,
      :omniclass_code,
      :grouping_zone,
      :notes
    )
  end
end
