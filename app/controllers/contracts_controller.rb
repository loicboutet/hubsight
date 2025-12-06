require 'ostruct'

class ContractsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contract, only: [:show, :edit, :update, :destroy, :validate, :confirm_validation, :apply_ai_value, :delete_pdf, :retry_ocr, :retry_extraction, :generate_pdf]

  def index
    # Get base query - admins see all, others see only their organization
    if current_user.admin?
      @contracts = Contract.all
    else
      @contracts = Contract.by_organization(current_user.organization_id)
    end
    
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
    
    # Store filter values for the view (17 total filters)
    @filter_params = {
      search: params[:search],
      site: params[:site],
      building: params[:building],
      type: params[:type],
      family: params[:family],
      subfamily: params[:subfamily],
      provider: params[:provider],
      renewal: params[:renewal],
      status: params[:status],
      signature_date_from: params[:signature_date_from],
      signature_date_to: params[:signature_date_to],
      start_date_from: params[:start_date_from],
      start_date_to: params[:start_date_to],
      end_date_from: params[:end_date_from],
      end_date_to: params[:end_date_to],
      amount_ht_min: params[:amount_ht_min],
      amount_ht_max: params[:amount_ht_max],
      amount_ttc_min: params[:amount_ttc_min],
      amount_ttc_max: params[:amount_ttc_max]
    }
    
    # Get unique values for filter dropdowns
    if current_user.admin?
      @sites = Site.order(:name)
      @buildings = Building.order(:name)
      @contract_types = Contract.distinct.pluck(:contract_type).compact.sort
    else
      @sites = Site.by_organization(current_user.organization_id).order(:name)
      @buildings = Building.by_organization(current_user.organization_id).order(:name)
      @contract_types = Contract.by_organization(current_user.organization_id).distinct.pluck(:contract_type).compact.sort
    end
    @families = ContractFamily.families_only.order(:display_order)
    @subfamilies = ContractFamily.subfamilies_only.order(:name)
    
    # Store sorting params
    @sort_column = params[:sort] || 'contract_number'
    @sort_direction = params[:direction] || 'asc'
    
    # Get column visibility preferences from session
    @visible_columns = session[:contract_columns] || default_columns
  end

  def show
    # Check authorization - admins can view all, others only their organization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Mock related contracts (amendments and framework agreements)
    @amendments = []
    @framework_agreements = []
  end

  def new
    if current_user.admin?
      # Admins don't have organization_id, so we leave it nil for them to select
      @contract = Contract.new
    else
      # For regular users, use their organization
      @contract = Contract.new(organization_id: current_user.organization_id)
      
      # For Portfolio Managers, auto-set client to their organization
      if current_user.portfolio_manager?
        @contract.client_organization_id = current_user.organization_id
        @contract.client_organization_name = current_user.organization&.name
      end
    end
  end

  def create
    @contract = Contract.new(contract_params)
    
    if current_user.admin?
      # If admin didn't select an organization, use the first available one
      @contract.organization_id = params[:contract][:organization_id].presence || Organization.first&.id
    else
      # For non-admin users, always use their organization
      @contract.organization_id = current_user.organization_id
      
      # For Portfolio Managers, if client_organization_id not provided, default to user's org
      if current_user.portfolio_manager? && @contract.client_organization_id.blank?
        @contract.client_organization_id = current_user.organization_id
        @contract.client_organization_name = current_user.organization&.name
      end
    end
    
    if @contract.save
      redirect_to contracts_path, notice: "Contrat créé avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Check authorization - admins can edit all, others only their organization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
  end

  def update
    # Check authorization - admins can update all, others only their organization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
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
    # Check authorization - admins can delete all, others only their organization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    @contract.destroy
    redirect_to contracts_path, notice: "Contrat supprimé avec succès"
  end

  def pdf
    # Renders contracts/pdf.html.erb or generates PDF
  end
  
  def generate_pdf
    # Check authorization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Generate PDF using shared service
    pdf_binary = ContractPdfGenerator.new(@contract).generate
    
    send_data pdf_binary,
      filename: "Contrat_#{@contract.contract_number}_#{Date.today.strftime('%Y%m%d')}.pdf",
      type: 'application/pdf',
      disposition: 'inline'
  end

  def validate
    # Check authorization
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
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
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    begin
      # Apply validation using new side-by-side comparison workflow
      @contract.apply_validation!(validation_params.to_h, current_user)
      
      redirect_to contract_path(@contract), notice: "Contrat validé avec succès"
    rescue => e
      flash.now[:alert] = "Erreur lors de la validation: #{e.message}"
      render :validate, status: :unprocessable_entity
    end
  end
  
  # AJAX endpoint - Apply AI value immediately when "Use AI" button is clicked
  def apply_ai_value
    # Get field and value from params
    field = params[:field]
    value = params[:value]
    
    # Validate field is in allowed list
    allowed_fields = Contract.validation_fields.values.flatten.map(&:to_s)
    
    unless allowed_fields.include?(field.to_s)
      render json: { success: false, error: "Champ non autorisé" }, status: :unprocessable_entity
      return
    end
    
    begin
      # Convert value based on field type
      converted_value = convert_value_for_field(field, value)
      
      # Update the contract field immediately
      @contract.update!(field => converted_value)
      
      # Track that this field was accepted from AI
      @contract.corrected_fields ||= {}
      @contract.corrected_fields[field] = 'llm_accepted'
      @contract.save!
      
      render json: { 
        success: true, 
        message: "Champ #{field} mis à jour avec succès",
        field: field,
        value: converted_value
      }
    rescue => e
      render json: { 
        success: false, 
        error: "Erreur lors de la sauvegarde: #{e.message}" 
      }, status: :unprocessable_entity
    end
  end

  def compare
    # Renders contracts/compare.html.erb
  end

  def delete_pdf
    # Check authorization
    # Admins can access all contracts across all organizations
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
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
    # Admins can access all contracts across all organizations
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
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
    # Admins can access all contracts across all organizations
    unless current_user.admin? || @contract.organization_id == current_user.organization_id
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
    
    # Building filter (NEW - Task 34)
    if params[:building].present?
      contracts = contracts.where(building_id: params[:building])
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
    
    # Date range filters (NEW - Task 34)
    # Signature date range
    if params[:signature_date_from].present?
      contracts = contracts.where("signature_date >= ?", params[:signature_date_from])
    end
    if params[:signature_date_to].present?
      contracts = contracts.where("signature_date <= ?", params[:signature_date_to])
    end
    
    # Start date range
    if params[:start_date_from].present?
      contracts = contracts.where("execution_start_date >= ?", params[:start_date_from])
    end
    if params[:start_date_to].present?
      contracts = contracts.where("execution_start_date <= ?", params[:start_date_to])
    end
    
    # End date range
    if params[:end_date_from].present?
      contracts = contracts.where("end_date >= ?", params[:end_date_from])
    end
    if params[:end_date_to].present?
      contracts = contracts.where("end_date <= ?", params[:end_date_to])
    end
    
    # Amount range filters (NEW - Task 34)
    # Amount HT range
    if params[:amount_ht_min].present?
      contracts = contracts.where("annual_amount_ht >= ?", params[:amount_ht_min].to_f)
    end
    if params[:amount_ht_max].present?
      contracts = contracts.where("annual_amount_ht <= ?", params[:amount_ht_max].to_f)
    end
    
    # Amount TTC range
    if params[:amount_ttc_min].present?
      contracts = contracts.where("annual_amount_ttc >= ?", params[:amount_ttc_min].to_f)
    end
    if params[:amount_ttc_max].present?
      contracts = contracts.where("annual_amount_ttc <= ?", params[:amount_ttc_max].to_f)
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

  # Convert value based on field type to handle different formats (especially dates)
  def convert_value_for_field(field, value)
    return nil if value.blank?
    
    # Get the field type from the model
    column = Contract.columns_hash[field.to_s]
    return value unless column
    
    case column.type
    when :date
      # Handle various date formats
      parse_date_value(value)
    when :boolean
      # Handle boolean values
      parse_boolean_value(value)
    when :integer
      value.to_i
    when :decimal, :float
      value.to_f
    else
      value
    end
  rescue => e
    Rails.logger.error("Error converting value for field #{field}: #{e.message}")
    value # Return original value if conversion fails
  end
  
  # Parse date from various formats
  def parse_date_value(value)
    return nil if value.blank?
    return value if value.is_a?(Date)
    
    # If already in ISO format (YYYY-MM-DD), return as is
    return value if value.match?(/^\d{4}-\d{2}-\d{2}$/)
    
    # Try to parse various date formats
    date_formats = [
      '%Y-%m-%d',           # 2024-01-15
      '%d/%m/%Y',           # 15/01/2024
      '%d-%m-%Y',           # 15-01-2024
      '%d.%m.%Y',           # 15.01.2024
      '%Y/%m/%d',           # 2024/01/15
      '%d %B %Y',           # 15 janvier 2024 (French)
      '%d %b %Y',           # 15 jan 2024
      '%B %d, %Y',          # January 15, 2024 (English)
      '%b %d, %Y'           # Jan 15, 2024
    ]
    
    # Try each format
    date_formats.each do |format|
      begin
        parsed_date = Date.strptime(value, format)
        return parsed_date.strftime('%Y-%m-%d')
      rescue ArgumentError, TypeError
        # Try next format
        next
      end
    end
    
    # If no format works, try Rails' default parsing
    begin
      Date.parse(value).strftime('%Y-%m-%d')
    rescue ArgumentError, TypeError => e
      Rails.logger.error("Unable to parse date value: #{value} - #{e.message}")
      value # Return original value if all parsing attempts fail
    end
  end
  
  # Parse boolean from various formats
  def parse_boolean_value(value)
    return true if value == true || value.to_s.downcase.in?(['true', '1', 'yes', 'oui', 't', 'y'])
    return false if value == false || value.to_s.downcase.in?(['false', '0', 'no', 'non', 'f', 'n'])
    nil
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
      :contract_family,
      
      # Organization references
      :contractor_organization_id,
      :client_organization_id
    )
  end
end
