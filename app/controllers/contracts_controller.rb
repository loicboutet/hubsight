require 'ostruct'

class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :validate, :confirm_validation, :delete_pdf, :retry_ocr, :retry_extraction]

  def index
    # Get base query scoped to current organization
    @contracts = Contract.by_organization(current_user.organization_id)
    
    # Apply filters
    @contracts = apply_filters(@contracts)
    
    # Apply sorting
    @contracts = apply_sorting(@contracts)
    
    # Get all contracts before pagination for counts
    @all_contracts_count = @contracts.count
    
    # Group contracts by type for display sections
    @leases = @contracts.where(contract_type: 'Bail').count
    @property_deeds = @contracts.where(contract_type: 'Acte de propriété').count
    @service_contracts_count = @contracts.where.not(contract_type: ['Bail', 'Acte de propriété']).count
    
    # Apply pagination (15 per page by default)
    @per_page = (params[:per_page] || 15).to_i
    @contracts = @contracts.page(params[:page]).per(@per_page)
    
    # Store filter values for the view
    @filter_params = {
      search: params[:search],
      site: params[:site],
      type: params[:type],
      family: params[:family],
      subfamily: params[:subfamily],
      provider: params[:provider],
      renewal: params[:renewal],
      status: params[:status]
    }
    
    # Get unique values for filter dropdowns
    @sites = Site.by_organization(current_user.organization_id).order(:name)
    @contract_types = Contract.by_organization(current_user.organization_id).distinct.pluck(:contract_type).compact.sort
    @families = ContractFamily.families_only.order(:display_order)
    @subfamilies = ContractFamily.subfamilies_only.order(:name)
    
    # Store sorting params
    @sort_column = params[:sort] || 'contract_number'
    @sort_direction = params[:direction] || 'asc'
    
    # Get column visibility preferences from session
    @visible_columns = session[:contract_columns] || default_columns
  end

  def show
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Mock related contracts (amendments and framework agreements)
    @amendments = []
    @framework_agreements = []
  end

  def new
    @contract = Contract.new(organization_id: current_user.organization_id)
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.organization_id = current_user.organization_id
    
    if @contract.save
      redirect_to contracts_path, notice: "Contrat créé avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
  end

  def update
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.update(contract_params)
      redirect_to contract_path(@contract), notice: "Contrat mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    @contract.destroy
    redirect_to contracts_path, notice: "Contrat supprimé avec succès"
  end

  def pdf
    # Renders contracts/pdf.html.erb or generates PDF
  end

  def validate
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Check if contract has completed extraction
    unless @contract.extraction_completed?
      redirect_to contract_path(@contract), alert: "L'extraction des données doit être terminée avant la validation"
      return
    end
    
    # Mark as in progress if still pending
    if @contract.validation_pending?
      @contract.update(validation_status: 'in_progress')
    end
  end

  def confirm_validation
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Update contract with validated data
    if @contract.update(validation_params)
      # Mark as validated
      @contract.update(
        validation_status: 'validated',
        validated_at: Time.current,
        validated_by: "#{current_user.first_name} #{current_user.last_name}".strip
      )
      
      redirect_to contract_path(@contract), notice: "Contrat validé avec succès"
    else
      render :validate, status: :unprocessable_entity
    end
  end

  def compare
    # Renders contracts/compare.html.erb
  end

  def upload
    # Renders contracts/upload.html.erb
  end

  def process_upload
    # Handle contract upload
    redirect_to contracts_path, notice: "Contrat importé avec succès"
  end

  def delete_pdf
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.pdf_document.attached?
      @contract.pdf_document.purge
      redirect_to edit_contract_path(@contract), notice: "PDF supprimé avec succès"
    else
      redirect_to edit_contract_path(@contract), alert: "Aucun PDF à supprimer"
    end
  end

  def retry_ocr
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.retry_ocr!
      redirect_to contract_path(@contract), notice: "Extraction OCR relancée avec succès"
    else
      redirect_to contract_path(@contract), alert: "Impossible de relancer l'extraction OCR. Aucun PDF attaché."
    end
  end
  
  def retry_extraction
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.retry_extraction!
      redirect_to contract_path(@contract), notice: "Extraction LLM relancée avec succès"
    else
      redirect_to contract_path(@contract), alert: "Impossible de relancer l'extraction. OCR non complété."
    end
  end
  
  # AJAX endpoint for updating column visibility
  def update_columns
    columns = params[:columns] || []
    session[:contract_columns] = columns
    head :ok
  end

  private
  
  def set_contract
    @contract = Contract.find(params[:id])
  end
  
  def apply_filters(contracts)
    # Search filter (contract number, title, contractor)
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      contracts = contracts.where(
        "contract_number LIKE ? OR title LIKE ? OR contractor_organization_name LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Site filter
    if params[:site].present?
      contracts = contracts.where(site_id: params[:site])
    end
    
    # Contract type filter
    if params[:type].present?
      contracts = contracts.where(contract_type: params[:type])
    end
    
    # Family filter
    if params[:family].present?
      # Match contract_family field which stores codes like "MAIN", "NETT", etc.
      contracts = contracts.where("contract_family LIKE ?", "#{params[:family]}%")
    end
    
    # Subfamily filter
    if params[:subfamily].present?
      contracts = contracts.where(purchase_subfamily: params[:subfamily])
    end
    
    # Provider filter
    if params[:provider].present?
      contracts = contracts.where("contractor_organization_name LIKE ?", "%#{params[:provider]}%")
    end
    
    # Renewal mode filter
    if params[:renewal].present?
      contracts = contracts.where(renewal_mode: params[:renewal])
    end
    
    # Status filter
    if params[:status].present?
      contracts = contracts.where(status: params[:status])
    end
    
    contracts
  end
  
  def apply_sorting(contracts)
    sort_column = params[:sort] || 'contract_number'
    sort_direction = params[:direction] || 'asc'
    
    # Validate sort column to prevent SQL injection
    allowed_columns = %w[
      contract_number title contractor_organization_name
      annual_amount_ht annual_amount_ttc
      signature_date execution_start_date end_date
      status contract_type purchase_subfamily
      created_at updated_at
    ]
    
    if allowed_columns.include?(sort_column)
      # Handle NULL values for date and amount columns
      if ['signature_date', 'execution_start_date', 'end_date'].include?(sort_column)
        # NULL dates go to the end
        contracts = contracts.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_direction}"))
      elsif ['annual_amount_ht', 'annual_amount_ttc'].include?(sort_column)
        # NULL amounts go to the end
        contracts = contracts.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_direction}"))
      else
        contracts = contracts.order("#{sort_column} #{sort_direction}")
      end
    else
      # Default sort
      contracts = contracts.order(contract_number: :asc)
    end
    
    contracts
  end
  
  def default_columns
    %w[
      contract_number title contractor_organization_name
      contract_type purchase_subfamily
      annual_amount_ht execution_start_date end_date
      status actions
    ]
  end
  
  def validation_params
    # Get all the extracted fields that can be validated/corrected
    params.require(:contract).permit(
      :title,
      :contract_object,
      :contract_type,
      :purchase_subfamily,
      :detailed_description,
      :contracting_method,
      :public_reference,
      :contractor_organization_name,
      :contractor_contact_name,
      :contractor_agency_name,
      :client_organization_name,
      :client_contact_name,
      :managing_department,
      :monitoring_manager,
      :contractor_phone,
      :contractor_email,
      :client_contact_email,
      :equipment_count,
      :geographic_areas,
      :building_names,
      :floor_levels,
      :specific_zones,
      :technical_lot,
      :equipment_categories,
      :coverage_description,
      :exclusions,
      :special_conditions,
      :scope_notes,
      :annual_amount_ht,
      :annual_amount_ttc,
      :monthly_amount,
      :billing_method,
      :billing_frequency,
      :payment_terms,
      :revision_conditions,
      :revision_index,
      :revision_frequency,
      :late_payment_penalties,
      :financial_guarantee,
      :deposit_amount,
      :price_revision_date,
      :last_amount_update,
      :budget_code,
      :signature_date,
      :execution_start_date,
      :initial_duration_months,
      :renewal_duration_months,
      :renewal_count,
      :automatic_renewal,
      :notice_period_days,
      :next_deadline_date,
      :last_renewal_date,
      :termination_date,
      :service_nature,
      :intervention_frequency,
      :intervention_delay_hours,
      :resolution_delay_hours,
      :working_hours,
      :on_call_24_7,
      :sla_percentage,
      :spare_parts_included,
      :supplies_included,
      :report_required,
      :validation_notes,
      covered_sites: [],
      covered_buildings: [],
      covered_equipment_types: [],
      kpis: [],
      appendix_documents: []
    )
  end

  def contract_params
    params.require(:contract).permit(
      # PDF Document
      :pdf_document,
      
      # Identification (8 fields)
      :contract_number,
      :title,
      :contract_type,
      :purchase_subfamily,
      :contract_object,
      :detailed_description,
      :contracting_method,
      :public_reference,
      
      # Parties Prenantes (10 fields)
      :contractor_organization_name,
      :contractor_contact_name,
      :contractor_agency_name,
      :client_organization_name,
      :client_contact_name,
      :contractor_email,
      :contractor_phone,
      :client_contact_email,
      :managing_department,
      :monitoring_manager,
      
      # Périmètre (15 fields)
      :site_id,
      :covered_sites,
      :covered_buildings,
      :covered_equipment_types,
      :covered_equipment_list,
      :equipment_count,
      :geographic_areas,
      :building_names,
      :floor_levels,
      :specific_zones,
      :technical_lot,
      :equipment_categories,
      :coverage_description,
      :exclusions,
      :special_conditions,
      :scope_notes,
      
      # Aspects Financiers (15 fields)
      :annual_amount_ht,
      :annual_amount_ttc,
      :monthly_amount,
      :billing_method,
      :billing_frequency,
      :payment_terms,
      :revision_conditions,
      :revision_index,
      :revision_frequency,
      :late_payment_penalties,
      :financial_guarantee,
      :deposit_amount,
      :price_revision_date,
      :last_amount_update,
      :budget_code,
      :vat_rate,
      
      # Temporalité (10 fields)
      :signature_date,
      :execution_start_date,
      :initial_duration_months,
      :renewal_duration_months,
      :renewal_count,
      :automatic_renewal,
      :notice_period_days,
      :next_deadline_date,
      :last_renewal_date,
      :termination_date,
      :renewal_mode,
      
      # Services & SLA (12 fields)
      :service_nature,
      :intervention_frequency,
      :intervention_delay_hours,
      :resolution_delay_hours,
      :working_hours,
      :on_call_24_7,
      :sla_percentage,
      :kpis,
      :spare_parts_included,
      :supplies_included,
      :report_required,
      :appendix_documents,
      
      # Other fields
      :status,
      :contract_family
    )
  end
end
