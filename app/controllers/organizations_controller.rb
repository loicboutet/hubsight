class OrganizationsController < ApplicationController
  def index
    # Renders organizations/index.html.erb
  end

  def show
    @organization = OpenStruct.new(
      id: params[:id],
      name: "ENGIE Solutions",
      legal_name: "ENGIE Solutions SAS",
      siret: "552 081 317 00426",
      organization_type: "Service provider",
      headquarters_address: "1 Place Samuel de Champlain",
      city: "Paris",
      postal_code: "75016",
      phone: "+33 1 40 06 20 00",
      email: "contact@engie-solutions.com",
      website: "https://www.engie-solutions.com",
      specialties: "HVAC, Energie, Maintenance multi-technique, Gestion technique des bâtiments",
      relationship_start_date: Date.new(2018, 3, 15),
      status: "active",
      notes: "Prestataire historique avec une excellente expertise en maintenance CVC et efficacité énergétique. Intervient sur la majorité de nos sites."
    )
  end

  def new
    @organization = OpenStruct.new(
      name: "",
      legal_name: "",
      siret: "",
      organization_type: "",
      headquarters_address: "",
      city: "",
      postal_code: "",
      phone: "",
      email: "",
      website: "",
      specialties: "",
      relationship_start_date: nil,
      status: "active",
      notes: ""
    )
  end

  def create
    # Handle organization creation
    redirect_to organizations_path, notice: "Organisation créée avec succès"
  end

  def edit
    @organization = OpenStruct.new(
      id: params[:id],
      name: "ENGIE Solutions",
      legal_name: "ENGIE Solutions SAS",
      siret: "552 081 317 00426",
      organization_type: "Service provider",
      headquarters_address: "1 Place Samuel de Champlain",
      city: "Paris",
      postal_code: "75016",
      phone: "+33 1 40 06 20 00",
      email: "contact@engie-solutions.com",
      website: "https://www.engie-solutions.com",
      specialties: "HVAC, Energie, Maintenance multi-technique, Gestion technique des bâtiments",
      relationship_start_date: Date.new(2018, 3, 15),
      status: "active",
      notes: "Prestataire historique avec une excellente expertise en maintenance CVC et efficacité énergétique. Intervient sur la majorité de nos sites."
    )
  end

  def update
    # Handle organization update
    redirect_to organization_path(params[:id]), notice: "Organisation mise à jour avec succès"
  end

  def destroy
    # Handle organization deletion
    redirect_to organizations_path, notice: "Organisation supprimée avec succès"
  end

  def search
    # Renders organizations/search.html.erb
  end
end
