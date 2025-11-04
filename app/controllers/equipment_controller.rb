class EquipmentController < ApplicationController
  def index
    # Renders equipment/index.html.erb
  end

  def show
    # Renders equipment/show.html.erb
  end

  def new
    # Renders equipment/new.html.erb
  end

  def create
    # Handle equipment creation
    # Space can come from nested route (params[:space_id]) or from form (params[:equipment][:space_id])
    space_id = params[:space_id] || params[:equipment][:space_id]
    
    # For now, just redirect to equipment index
    # In production, you would save the equipment with the space_id here
    redirect_to equipment_index_path
  end

  def edit
    # Renders equipment/edit.html.erb
  end

  def update
    # Handle equipment update
    redirect_to equipment_path(params[:id])
  end

  def destroy
    # Handle equipment deletion
    redirect_to equipment_index_path
  end

  def search
    # Renders equipment/search.html.erb
  end
end
