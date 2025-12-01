class AgenciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_agency, only: [:show, :edit, :update, :destroy]
  
  def index
    @agencies = Agency.includes(:organization)
                     .ordered
                     .page(params[:page])
                     .per(50)
    
    if params[:search].present?
      @agencies = @agencies.search(params[:search])
    end
  end
  
  def show
  end
  
  def new
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    @agency = @organization ? @organization.agencies.build : Agency.new
  end
  
  def create
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    @agency = @organization ? @organization.agencies.build(agency_params) : Agency.new(agency_params)
    
    if @agency.save
      redirect_to @organization || @agency, notice: 'Agence créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @agency.update(agency_params)
      redirect_to @agency, notice: 'Agence mise à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    organization = @agency.organization
    @agency.destroy
    redirect_to organization || agencies_path, notice: 'Agence supprimée avec succès.'
  end
  
  def search
    @agencies = Agency.includes(:organization)
                     .search(params[:query])
                     .ordered
                     .limit(10)
    
    render json: @agencies.as_json(
      only: [:id, :name, :code, :city, :phone, :agency_type],
      methods: [:display_name, :type_label],
      include: {
        organization: { only: [:id, :name] }
      }
    )
  end
  
  private
  
  def set_agency
    @agency = Agency.find(params[:id])
  end
  
  def agency_params
    params.require(:agency).permit(
      :organization_id,
      :name,
      :code,
      :agency_type,
      :address,
      :city,
      :postal_code,
      :region,
      :phone,
      :email,
      :service_area,
      :certifications,
      :specialties,
      :manager_name,
      :manager_contact,
      :operating_hours,
      :notes,
      :status
    )
  end
end
