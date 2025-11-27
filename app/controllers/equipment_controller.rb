class EquipmentController < ApplicationController
  def index
    # Mock equipment data for Item 29 - Deletion Confirmation
    @equipment_list = [
      { id: 1, name: 'Climatiseur Daikin AC-500', type: 'Climatisation', category: 'CVC - HVAC', manufacturer: 'Daikin', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '15/12/2024', location: 'Bureau 101 - RDC - Bât. A', criticality: 'Élevé', service_provider: 'Climatisation - Daikin', installation_date: '12/03/2020', under_warranty: true },
      { id: 2, name: 'Détecteur Incendie FireGuard', type: 'Sécurité Incendie', category: 'SEC - Sécurité', manufacturer: 'Honeywell', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '10/01/2025', location: 'Bureau 101 - RDC - Bât. A', criticality: 'Critique', service_provider: nil, installation_date: '05/06/2018', under_warranty: false },
      { id: 3, name: 'Luminaire LED Panel 60x60', type: 'Éclairage', category: 'ELE - Électricité', manufacturer: 'Philips', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '05/01/2025', location: 'Bureau 101 - RDC - Bât. A', criticality: 'Faible', service_provider: 'Éclairage - Philips', installation_date: '15/09/2021', under_warranty: false },
      { id: 4, name: 'Chaudière Viessmann VB-200', type: 'Chauffage', category: 'CVC - HVAC', manufacturer: 'Viessmann', status: 'En maintenance', status_color: '#fff3cd', status_text_color: '#856404', last_maintenance: '20/12/2024', location: 'Chaufferie - SS1 - Bât. A', criticality: 'Critique', service_provider: 'Chauffage - Viessmann', installation_date: '10/11/2019', under_warranty: true },
      { id: 5, name: 'VMC Aldes Bahia', type: 'Ventilation', category: 'CVC - HVAC', manufacturer: 'Aldes', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '28/12/2024', location: 'Bureau 205 - 2ème - Bât. A', criticality: 'Moyen', service_provider: 'Ventilation - Aldes', installation_date: '22/04/2020', under_warranty: false },
      { id: 6, name: 'Tableau Électrique Schneider TE-45', type: 'Tableau électrique', category: 'ELE - Électricité', manufacturer: 'Schneider Electric', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '18/12/2024', location: 'Local technique - RDC - Bât. A', criticality: 'Élevé', service_provider: nil, installation_date: '08/02/2017', under_warranty: false },
      { id: 7, name: 'Ascenseur OTIS Gen2', type: 'Ascenseur', category: 'ASC - Ascenseurs', manufacturer: 'OTIS', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '22/01/2025', location: 'Hall principal - RDC - Bât. A', criticality: 'Critique', service_provider: 'Ascenseurs - OTIS', installation_date: '14/07/2023', under_warranty: true },
      { id: 8, name: 'Chauffe-eau Thermor ACI+ 300L', type: 'Chauffe-eau', category: 'PLO - Plomberie', manufacturer: 'Thermor', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '12/01/2025', location: 'Sanitaires - 1er - Bât. A', criticality: 'Moyen', service_provider: 'Plomberie - Thermor', installation_date: '30/05/2021', under_warranty: false },
      { id: 9, name: 'Extincteur CO2 5kg', type: 'Extincteur', category: 'SEC - Sécurité', manufacturer: 'Gloria', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '15/11/2024', location: 'Couloir - 1er - Bât. A', criticality: 'Élevé', service_provider: 'Sécurité - Gloria', installation_date: '18/01/2022', under_warranty: true },
      { id: 10, name: 'Pompe Circulation Grundfos UPS', type: 'Pompe', category: 'PLO - Plomberie', manufacturer: 'Grundfos', status: 'Hors service', status_color: '#f8d7da', status_text_color: '#721c24', last_maintenance: '08/12/2024', location: 'Chaufferie - SS1 - Bât. A', criticality: 'Élevé', service_provider: nil, installation_date: '25/03/2016', under_warranty: false },
      { id: 11, name: 'Climatiseur Split Samsung AR09', type: 'Climatisation', category: 'CVC - HVAC', manufacturer: 'Samsung', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '19/01/2025', location: 'Bureau 302 - 3ème - Bât. A', criticality: 'Moyen', service_provider: 'Climatisation - Samsung', installation_date: '11/08/2022', under_warranty: true },
      { id: 12, name: 'Alarme Intrusion Paradox SP7000', type: 'Alarme intrusion', category: 'SEC - Sécurité', manufacturer: 'Paradox', status: 'Actif', status_color: '#d4edda', status_text_color: '#155724', last_maintenance: '03/01/2025', location: 'Entrée principale - RDC - Bât. A', criticality: 'Critique', service_provider: 'Sécurité - Paradox', installation_date: '02/12/2023', under_warranty: true }
    ]
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
