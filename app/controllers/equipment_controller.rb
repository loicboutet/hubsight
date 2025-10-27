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
