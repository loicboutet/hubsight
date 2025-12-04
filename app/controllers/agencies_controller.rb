class AgenciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_agency, only: [:show, :edit, :update, :destroy]
  
  def index
    # Apply organization-based filtering for data isolation
    # Admin sees all agencies, other users see only their organization's agencies
    if current_user.admin?
      @agencies = Agency.includes(:organization)
    else
      @agencies = Agency.includes(:organization)
                       .where(organization_id: current_user.organization_id)
    end
    
    # Apply sorting and pagination
    @agencies = @agencies.ordered
                         .page(params[:page])
                         .per(20)
    
    # Apply additional filters
    if params[:search].present?
      @agencies = @agencies.search(params[:search])
    end
    
    if params[:agency_type].present?
      @agencies = @agencies.by_type(params[:agency_type])
    end
    
    if params[:organization_id].present?
      @agencies = @agencies.by_organization(params[:organization_id])
    end
  end
  
  def show
  end
  
  def new
    # For admin users accessing from organization page
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    
    # For non-admin users, auto-assign their organization
    if current_user.admin?
      @agency = @organization ? @organization.agencies.build : Agency.new
    else
      @agency = current_user.organization.agencies.build
    end
  end
  
  def create
    # For non-admin users, force organization assignment from backend
    if current_user.admin?
      @organization = Organization.find(params[:organization_id]) if params[:organization_id]
      @agency = @organization ? @organization.agencies.build(agency_params) : Agency.new(agency_params)
    else
      # Portfolio managers: explicitly assign to their organization
      @agency = current_user.organization.agencies.build(agency_params)
      @agency.organization_id = current_user.organization_id # Ensure it's set from backend
    end
    
    if @agency.save
      redirect_to @agency, notice: 'Agence créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @organization = @agency.organization
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
    # Apply organization-based filtering for search results
    if current_user.admin?
      @agencies = Agency.includes(:organization)
    else
      @agencies = Agency.includes(:organization)
                       .where(organization_id: current_user.organization_id)
    end
    
    @agencies = @agencies.search(params[:query])
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
    # Admin can access all agencies, other users can only access their organization's agencies
    if current_user.admin?
      @agency = Agency.find(params[:id])
    else
      @agency = Agency.where(organization_id: current_user.organization_id).find(params[:id])
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to agencies_path, alert: "Agence introuvable ou accès non autorisé"
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
