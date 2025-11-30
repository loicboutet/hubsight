class SiteManager::ContractsController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :authenticate_user!
  before_action :ensure_site_manager_role
  before_action :set_contract, only: [:show, :pdf]
  
  def index
    # Get all contracts for sites assigned to this site manager
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    
    @contracts = Contract.where(site_id: assigned_site_ids)
                        .where(organization_id: current_user.organization_id)
                        .includes(:site, :organization)
                        .order('sites.name ASC, contracts.contract_number ASC')
    
    # Apply filters if present
    if params[:site_id].present?
      @contracts = @contracts.where(site_id: params[:site_id])
    end
    
    if params[:family].present?
      @contracts = @contracts.where(contract_family: params[:family])
    end
    
    if params[:status].present?
      @contracts = @contracts.where(status: params[:status])
    end
    
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @contracts = @contracts.where(
        "contract_number LIKE ? OR title LIKE ? OR contractor_organization LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Group contracts by site for better organization
    @contracts_by_site = @contracts.group_by(&:site)
    
    # Pagination
    @contracts = @contracts.page(params[:page]).per(15)
    
    # Get assigned sites for filter dropdown
    @assigned_sites = current_user.assigned_sites.order(:name)
    
    # Check if site manager has any assigned sites
    unless has_assigned_sites?
      flash.now[:alert] = "Aucun site ne vous a été assigné. Vous ne pouvez pas voir de contrats."
    end
  end

  def show
    # Contract details are loaded in before_action
    # This is a read-only view
  end
  
  def pdf
    if @contract.pdf_attached?
      redirect_to rails_blob_path(@contract.pdf_document, disposition: "inline")
    else
      redirect_to my_contract_path(@contract), alert: "Aucun PDF disponible pour ce contrat."
    end
  end
  
  private
  
  def ensure_site_manager_role
    unless current_user.site_manager?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
  def set_contract
    # Only allow access to contracts from assigned sites
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    @contract = Contract.where(site_id: assigned_site_ids)
                       .where(organization_id: current_user.organization_id)
                       .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_contracts_path, alert: "Vous n'avez pas accès à ce contrat."
  end
end
