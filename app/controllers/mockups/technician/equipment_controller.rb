class Mockups::Technician::EquipmentController < ApplicationController
  layout 'mockup_technician'
  
  def index
    # Renders technician/equipment/index.html.erb
  end

  def show
    # Renders technician/equipment/show.html.erb
  end

  def new
    # Renders technician/equipment/new.html.erb
  end

  def create
    # Handle equipment creation
    redirect_to mockups_technician_equipment_index_path
  end

  def edit
    # Renders technician/equipment/edit.html.erb
  end

  def update
    # Handle equipment update
    redirect_to mockups_technician_equipment_path(params[:id])
  end

  def destroy
    # Handle equipment deletion
    redirect_to mockups_technician_equipment_index_path
  end

  def search
    # Renders technician/equipment/search.html.erb
  end
end
