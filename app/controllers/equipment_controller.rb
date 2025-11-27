class EquipmentController < ApplicationController
  def index
    # Renders equipment/index.html.erb
  end

  def show
    @equipment = OpenStruct.new(
      id: params[:id],
      name: "Climatiseur Daikin AC-500",
      equipment_type: "HVAC - Climatiseur",
      manufacturer: "Daikin",
      model: "AC-500",
      serial_number: "SN123456789",
      status: "active",
      power_rating: 3.5,
      installation_date: Date.parse("2024-03-01"),
      warranty_end_date: Date.parse("2027-03-01"),
      
      # Item 13: Data Source Tracking fields
      created_by: "Sophie Martin",
      created_at: "12/03/2024 à 16:45",
      updated_by: "Pierre Dubois",
      updated_at: "20/11/2024 à 11:20",
      import_source: "Excel",
      import_date: "10/03/2024 à 14:30",
      import_user: "Admin Système"
    )
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
