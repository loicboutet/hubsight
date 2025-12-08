class SiteManager::ContractsController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :authenticate_user!
  before_action :ensure_site_manager_role
  before_action :set_contract, only: [:show, :pdf, :generate_summary_pdf]
  before_action :load_assigned_sites, only: [:new, :create, :upload, :process_upload]
  
  def index
    # Get all contracts for sites assigned to this site manager
    assigned_site_ids = current_user.assigned_sites.pluck(:id)
    
    @contracts = Contract.where(site_id: assigned_site_ids)
                        .where(organization_id: current_user.organization_id)
                        .includes(:site, :organization)
                        .order('sites.name ASC, contracts.contract_number ASC')
    
    # ITEM 3: Apply default filters (same as main contracts - Maintenance + Active)
    @filter_params = apply_default_filters
    
    # Apply filters
    if @filter_params[:site_id].present?
      @contracts = @contracts.where(site_id: @filter_params[:site_id])
    end
    
    if @filter_params[:family].present?
      @contracts = @contracts.where("contract_family LIKE ?", "#{@filter_params[:family]}%")
    end
    
    if @filter_params[:status].present?
      @contracts = @contracts.where(status: @filter_params[:status])
    end
    
    if @filter_params[:search].present?
      search_term = "%#{@filter_params[:search]}%"
      @contracts = @contracts.where(
        "contract_number LIKE ? OR title LIKE ? OR contractor_organization_name LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Get assigned sites for filter dropdown
    @assigned_sites = current_user.assigned_sites.order(:name)
    
    # Group contracts by site for better organization
    @contracts_by_site = @contracts.group_by(&:site)
    
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
  
  def generate_summary_pdf
    # Authorization already handled by set_contract before_action
    # Generate PDF using shared service
    pdf_binary = ContractPdfGenerator.new(@contract).generate
    
    send_data pdf_binary,
      filename: "Contrat_#{@contract.contract_number}_#{Date.today.strftime('%Y%m%d')}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end
  
  def new
    @contract = Contract.new
  end
  
  def create
    @contract = Contract.new(contract_params)
    @contract.organization_id = current_user.organization_id
    
    # Validate that the selected site is assigned to this site manager
    unless current_user.assigned_sites.pluck(:id).include?(@contract.site_id)
      redirect_to new_my_contract_path, alert: "Vous ne pouvez créer un contrat que pour vos sites assignés."
      return
    end
    
    if @contract.save
      # OCR extraction will be triggered automatically via after_commit callback
      redirect_to my_contract_path(@contract), notice: "Contrat créé avec succès. L'extraction des données va démarrer automatiquement."
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def upload
    # Display simplified upload form
  end
  
  def process_upload
    # Alias for create - handles the same workflow
    create
  end
  
  private
  
  # ITEM 3: Apply default filters for site manager (Maintenance + Active)
  def apply_default_filters
    # Check if user explicitly cleared filters
    if params[:clear_filters] == 'true'
      return {
        search: nil,
        site_id: nil,
        family: nil,
        status: nil
      }
    end
    
    # Check if any filter parameters are present
    filter_keys = [:search, :site_id, :family, :status]
    has_filters = filter_keys.any? { |key| params[key].present? }
    
    # If no filters, apply defaults
    if !has_filters
      {
        search: nil,
        site_id: nil,
        family: 'MAIN',      # Default: Maintenance contracts
        status: 'active'     # Default: Active contracts
      }
    else
      # Use provided filters
      {
        search: params[:search],
        site_id: params[:site_id],
        family: params[:family],
        status: params[:status]
      }
    end
  end
  
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
  
  def load_assigned_sites
    @assigned_sites = current_user.assigned_sites.order(:name)
    
    unless @assigned_sites.any?
      redirect_to my_contracts_path, alert: "Aucun site ne vous a été assigné. Vous ne pouvez pas créer de contrats."
    end
  end
  
  def contract_params
    params.require(:contract).permit(
      :site_id,
      :pdf_document,
      :contract_number,
      :title,
      :contract_type,
      :contract_family,
      :purchase_subfamily,
      :status,
      :contract_object,
      :contractor_organization_name,
      :contractor_contact_name,
      :contractor_email,
      :contractor_phone,
      :annual_amount_ht,
      :annual_amount_ttc,
      :billing_method,
      :billing_frequency,
      :signature_date,
      :start_date,
      :end_date,
      :initial_duration_months,
      :automatic_renewal,
      :notice_period_days
    )
  end
end
