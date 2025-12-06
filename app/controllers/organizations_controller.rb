class OrganizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_organization_access, except: [:autocomplete]
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
                                .search(params[:search])
                                .by_type(params[:organization_type])
                                .ordered
                                .page(params[:page]).per(15)
  end

  def show
    # @organization set by before_action
  end

  def new
    @organization = Organization.new(status: 'active')
  end

  def create
    @organization = Organization.new(organization_params)

    if @organization.save
      redirect_to @organization, notice: 'Organisation créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @organization set by before_action
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: 'Organisation mise à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @organization.destroy
      redirect_to organizations_path, notice: 'Organisation supprimée avec succès.'
    else
      redirect_to @organization, alert: "Impossible de supprimer cette organisation : #{@organization.errors.full_messages.join(', ')}"
    end
  end

  def search
    @organizations = Organization.search(params[:q])
                                .ordered
                                .limit(50)
    render json: @organizations
  end

  def autocomplete
    query = params[:query].to_s.strip
    
    if query.length < 2
      render json: { organizations: [] }
      return
    end
    
    # Search across ALL organizations (not scoped to current user's org)
    organizations = Organization.active
                                .search(query)
                                .ordered
                                .limit(50)
    
    # Build response with organization details
    results = organizations.map do |org|
      {
        id: org.id,
        name: org.name,
        legal_name: org.legal_name,
        display_name: org.display_name,
        organization_type: org.organization_type,
        type_label: org.type_label,
        siret: org.siret,
        formatted_siret: org.formatted_siret,
        phone: org.phone,
        email: org.email,
        website: org.website,
        headquarters_address: org.headquarters_address,
        specialties: org.specialties,
        status: org.status
      }
    end
    
    render json: { organizations: results }
  rescue => e
    Rails.logger.error "Organizations autocomplete error: #{e.message}"
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_organization
    @organization = Organization.find(params[:id])
  end

  def organization_params
    params.require(:organization).permit(
      :name,
      :legal_name,
      :siret,
      :organization_type,
      :headquarters_address,
      :phone,
      :email,
      :website,
      :specialties,
      :relationship_start_date,
      :status,
      :notes
    )
  end

  def require_organization_access
    unless current_user&.portfolio_manager? || current_user&.admin?
      redirect_to root_path, alert: 'Accès non autorisé. Seuls les administrateurs et les gestionnaires de portefeuille peuvent gérer les organisations.'
    end
  end
end
