# frozen_string_literal: true

# Service class for exporting contract list to Excel
# Respects current filters and column visibility preferences
class ContractListExporter
  def initialize(organization, filter_params = {}, visible_columns = [])
    @organization = organization
    @filter_params = filter_params
    @visible_columns = visible_columns.presence || default_columns
  end

  def generate
    package = Axlsx::Package.new
    workbook = package.workbook
    
    # Create styles
    @header_style = workbook.styles.add_style(
      bg_color: '4F46E5',
      fg_color: 'FFFFFF',
      b: true,
      sz: 11,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )

    generate_contracts_sheet(workbook)

    package.to_stream.read
  end

  private

  def generate_contracts_sheet(workbook)
    workbook.add_worksheet(name: 'Liste des Contrats') do |sheet|
      add_header(sheet)
      add_contract_data(sheet)
      apply_formatting(sheet)
    end
  end

  def add_header(sheet)
    headers = []
    
    # Build header row based on visible columns
    headers << 'N° Contrat' if column_visible?('contract_number')
    headers << 'Titre' if column_visible?('title')
    headers << 'Prestataire' if column_visible?('contractor_organization_name')
    headers << 'Type' if column_visible?('contract_type')
    headers << 'Famille' if @visible_columns.include?('contract_family')
    headers << 'Sous-famille' if column_visible?('purchase_subfamily')
    headers << 'Site' if @visible_columns.include?('site')
    headers << 'Montant HT' if column_visible?('annual_amount_ht')
    headers << 'Montant TTC' if @visible_columns.include?('annual_amount_ttc')
    headers << 'Date Signature' if @visible_columns.include?('signature_date')
    headers << 'Date Début' if column_visible?('execution_start_date')
    headers << 'Date Fin' if column_visible?('end_date')
    headers << 'Statut' if column_visible?('status')
    
    sheet.add_row headers, style: @header_style
  end

  def add_contract_data(sheet)
    contracts_list.each do |contract|
      row = []
      
      row << (contract.contract_number || '-') if column_visible?('contract_number')
      row << (contract.title || '-') if column_visible?('title')
      row << (contract.contractor_organization_name || '-') if column_visible?('contractor_organization_name')
      row << (contract.contract_type || '-') if column_visible?('contract_type')
      row << format_family(contract) if @visible_columns.include?('contract_family')
      row << (contract.purchase_subfamily || '-') if column_visible?('purchase_subfamily')
      row << (contract.site&.name || '-') if @visible_columns.include?('site')
      row << format_currency(contract.annual_amount_ht) if column_visible?('annual_amount_ht')
      row << format_currency(contract.annual_amount_ttc) if @visible_columns.include?('annual_amount_ttc')
      row << format_date(contract.signature_date) if @visible_columns.include?('signature_date')
      row << format_date(contract.execution_start_date) if column_visible?('execution_start_date')
      row << format_date(contract.end_date) if column_visible?('end_date')
      row << format_status(contract.status) if column_visible?('status')
      
      sheet.add_row row
    end
  end

  def apply_formatting(sheet)
    # Freeze header row
    sheet.sheet_view.pane do |pane|
      pane.top_left_cell = 'A2'
      pane.state = :frozen
      pane.y_split = 1
    end

    # Set column widths dynamically based on visible columns
    widths = []
    widths << 20 if column_visible?('contract_number')      # N° Contrat
    widths << 35 if column_visible?('title')                # Titre
    widths << 25 if column_visible?('contractor_organization_name')  # Prestataire
    widths << 20 if column_visible?('contract_type')        # Type
    widths << 25 if @visible_columns.include?('contract_family')     # Famille
    widths << 25 if column_visible?('purchase_subfamily')   # Sous-famille
    widths << 25 if @visible_columns.include?('site')       # Site
    widths << 15 if column_visible?('annual_amount_ht')     # Montant HT
    widths << 15 if @visible_columns.include?('annual_amount_ttc')   # Montant TTC
    widths << 15 if @visible_columns.include?('signature_date')      # Date Signature
    widths << 15 if column_visible?('execution_start_date') # Date Début
    widths << 15 if column_visible?('end_date')             # Date Fin
    widths << 15 if column_visible?('status')               # Statut
    
    sheet.column_widths(*widths)
  end

  # =============================================================================
  # HELPER METHODS
  # =============================================================================

  def contracts_list
    @contracts_list ||= begin
      contracts = Contract.by_organization(@organization.id)
      contracts = apply_filters(contracts)
      contracts = apply_sorting(contracts)
      contracts.includes(:site)
    end
  end

  def apply_filters(contracts)
    # Search filter
    if @filter_params[:search].present?
      search_term = "%#{@filter_params[:search]}%"
      contracts = contracts.where(
        "contract_number LIKE ? OR title LIKE ? OR contractor_organization_name LIKE ?",
        search_term, search_term, search_term
      )
    end
    
    # Site filter
    if @filter_params[:site].present?
      contracts = contracts.where(site_id: @filter_params[:site])
    end
    
    # Contract type filter
    if @filter_params[:type].present?
      contracts = contracts.where(contract_type: @filter_params[:type])
    end
    
    # Family filter
    if @filter_params[:family].present?
      contracts = contracts.where("contract_family LIKE ?", "#{@filter_params[:family]}%")
    end
    
    # Subfamily filter
    if @filter_params[:subfamily].present?
      contracts = contracts.where(purchase_subfamily: @filter_params[:subfamily])
    end
    
    # Provider filter
    if @filter_params[:provider].present?
      contracts = contracts.where("contractor_organization_name LIKE ?", "%#{@filter_params[:provider]}%")
    end
    
    # Status filter
    if @filter_params[:status].present?
      contracts = contracts.where(status: @filter_params[:status])
    end
    
    contracts
  end

  def apply_sorting(contracts)
    sort_column = @filter_params[:sort] || 'contract_number'
    sort_direction = @filter_params[:direction] || 'asc'
    
    allowed_columns = %w[
      contract_number title contractor_organization_name
      annual_amount_ht annual_amount_ttc
      signature_date execution_start_date end_date
      status contract_type purchase_subfamily
    ]
    
    if allowed_columns.include?(sort_column)
      if ['signature_date', 'execution_start_date', 'end_date'].include?(sort_column)
        contracts = contracts.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_direction}"))
      elsif ['annual_amount_ht', 'annual_amount_ttc'].include?(sort_column)
        contracts = contracts.order(Arel.sql("#{sort_column} IS NULL, #{sort_column} #{sort_direction}"))
      else
        contracts = contracts.order("#{sort_column} #{sort_direction}")
      end
    else
      contracts = contracts.order(contract_number: :asc)
    end
    
    contracts
  end

  def column_visible?(column_name)
    @visible_columns.include?(column_name)
  end

  def default_columns
    %w[
      contract_number title contractor_organization_name
      contract_type purchase_subfamily
      annual_amount_ht execution_start_date end_date
      status
    ]
  end

  def header_style
    {
      bg_color: '4F46E5',
      fg_color: 'FFFFFF',
      b: true,
      sz: 11,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    }
  end

  def format_date(date)
    return '-' if date.nil?
    date.strftime('%d/%m/%Y')
  end

  def format_currency(value)
    return '-' if value.nil?
    "#{value.to_f.round(2)} €"
  end

  def format_status(status)
    return '-' if status.nil?
    
    case status
    when 'active'
      'Actif'
    when 'pending'
      'En attente'
    when 'expired'
      'Expiré'
    when 'suspended'
      'Suspendu'
    else
      status
    end
  end

  def format_family(contract)
    return '-' if contract.contract_family.blank?
    
    # If contract has family object, use it
    if contract.respond_to?(:contract_family_object) && contract.contract_family_object
      contract.contract_family_object.display_name
    else
      contract.contract_family
    end
  end
end
