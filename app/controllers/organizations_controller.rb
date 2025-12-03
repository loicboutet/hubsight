class OrganizationsController < ApplicationController
  before_action :require_organization_access
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
