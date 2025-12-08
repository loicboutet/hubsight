class Contract < ApplicationRecord
  belongs_to :organization
  belongs_to :site, optional: true
  
  # Organization relationships for contractor and client
  belongs_to :contractor_organization, class_name: 'Organization', optional: true
  belongs_to :client_organization, class_name: 'Organization', optional: true

  # ActiveStorage attachment for PDF document
  has_one_attached :pdf_document

  # Validations
  validates :organization_id, presence: true
  validates :contract_number, presence: true
  validates :title, presence: true
  validates :contract_type, presence: true
  validates :contractor_organization_name, presence: true
  validates :contract_object, presence: true
  validates :status, inclusion: { in: %w[active expired pending suspended] }, allow_nil: true
  validates :annual_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ocr_status, inclusion: { in: %w[pending processing completed failed] }, allow_nil: true
  validates :extraction_status, inclusion: { in: %w[pending processing completed failed] }, allow_nil: true
  validates :validation_status, inclusion: { in: %w[pending in_progress validated] }, allow_nil: true
  validates :vat_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  
  # PDF validations - OPTIONAL for manual contract creation
  validate :pdf_document_validation, if: -> { pdf_document.attached? }

  # Callbacks
  before_save :calculate_contract_dates
  before_save :calculate_vat_amounts
  before_save :track_amount_updates
  before_save :sync_organization_names
  before_save :reset_extraction_on_pdf_change
  after_commit :trigger_ocr_extraction, on: [:create, :update], if: :should_trigger_ocr?
  after_commit :trigger_llm_extraction, on: [:update], if: :should_trigger_llm?

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_family, ->(family) { where(contract_family: family) }
  scope :by_status, ->(status) { where(status: status) }
  scope :in_date_range, ->(start_date, end_date) { where('start_date >= ? AND start_date <= ?', start_date, end_date) }
  scope :for_site_manager, ->(user) { 
    where(site_id: user.assigned_sites.pluck(:id))
      .where(organization_id: user.organization_id) 
  }
  
  # OCR Scopes
  scope :ocr_pending, -> { where(ocr_status: 'pending') }
  scope :ocr_processing, -> { where(ocr_status: 'processing') }
  scope :ocr_completed, -> { where(ocr_status: 'completed') }
  scope :ocr_failed, -> { where(ocr_status: 'failed') }
  
  # LLM Extraction Scopes
  scope :extraction_pending, -> { where(extraction_status: 'pending') }
  scope :extraction_processing, -> { where(extraction_status: 'processing') }
  scope :extraction_completed, -> { where(extraction_status: 'completed') }
  scope :extraction_failed, -> { where(extraction_status: 'failed') }
  scope :needs_extraction, -> { ocr_completed.where(extraction_status: [nil, 'pending', 'failed']) }

  # Organization Display Helper Methods
  
  # Display contractor organization name with fallback
  def contractor_display_name
    contractor_organization&.name || contractor_organization_name || '—'
  end
  
  # Display client organization name with fallback
  def client_display_name
    client_organization&.name || client_organization_name || '—'
  end
  
  # Contract Family Integration Methods
  
  # Returns the ContractFamily object by looking up contract_family string
  # This provides access to the classification system
  def contract_family_object
    return nil if contract_family.blank?
    # Try to find by code first (e.g., "MAIN-CVC")
    family = ContractFamily.find_by(code: contract_family)
    return family if family
    
    # Try to find by name (e.g., "Maintenance CVC")
    ContractFamily.find_by(name: contract_family)
  end

  # Returns formatted display of contract family
  def family_display_name
    family_obj = contract_family_object
    return contract_family if family_obj.nil?
    family_obj.display_name
  end

  # Returns the hierarchy path for the contract family
  def family_hierarchy
    family_obj = contract_family_object
    return contract_family if family_obj.nil?
    family_obj.hierarchy_path
  end

  # Check if contract has a valid family classification
  def has_family_classification?
    contract_family_object.present?
  end

  # PDF helper methods
  def pdf_attached?
    pdf_document.attached?
  end

  def pdf_filename
    pdf_document.filename.to_s if pdf_attached?
  end

  def pdf_filesize
    pdf_document.byte_size if pdf_attached?
  end

  def pdf_filesize_mb
    (pdf_filesize.to_f / 1.megabyte).round(2) if pdf_attached?
  end

  def pdf_url
    Rails.application.routes.url_helpers.rails_blob_path(pdf_document, disposition: "attachment") if pdf_attached?
  end

  # OCR helper methods
  def ocr_completed?
    ocr_status == 'completed'
  end

  def ocr_in_progress?
    ocr_status == 'processing'
  end

  def ocr_pending?
    ocr_status == 'pending'
  end

  def ocr_failed?
    ocr_status == 'failed'
  end

  def needs_ocr?
    pdf_attached? && (ocr_status.nil? || ocr_status == 'pending' || ocr_status == 'failed')
  end

  def ocr_status_badge_color
    case ocr_status
    when 'completed' then 'green'
    when 'processing' then 'blue'
    when 'failed' then 'red'
    when 'pending' then 'yellow'
    else 'gray'
    end
  end

  def ocr_status_display
    case ocr_status
    when 'completed' then 'Terminé'
    when 'processing' then 'En cours'
    when 'failed' then 'Échec'
    when 'pending' then 'En attente'
    else 'Non traité'
    end
  end

  # Retry OCR extraction
  def retry_ocr!
    return false unless pdf_attached?
    
    update(ocr_status: 'pending', ocr_error_message: nil)
    ExtractContractOcrJob.perform_later(id)
    true
  end
  
  # LLM Extraction helper methods
  def extraction_completed?
    extraction_status == 'completed'
  end
  
  def extraction_in_progress?
    extraction_status == 'processing'
  end
  
  def extraction_pending?
    extraction_status == 'pending'
  end
  
  def extraction_failed?
    extraction_status == 'failed'
  end
  
  def needs_extraction?
    ocr_completed? && (extraction_status.nil? || extraction_status == 'pending' || extraction_status == 'failed')
  end
  
  def extraction_status_badge_color
    case extraction_status
    when 'completed' then 'green'
    when 'processing' then 'blue'
    when 'failed' then 'red'
    when 'pending' then 'yellow'
    else 'gray'
    end
  end
  
  def extraction_status_display
    case extraction_status
    when 'completed' then 'Terminé'
    when 'processing' then 'En cours'
    when 'failed' then 'Échec'
    when 'pending' then 'En attente'
    else 'Non traité'
    end
  end
  
  # Retry LLM extraction
  def retry_extraction!
    return false unless ocr_completed?
    
    update(extraction_status: 'pending', extraction_notes: nil)
    ExtractContractDataJob.perform_later(id)
    true
  end
  
  # Check if using demo/mock provider
  def using_demo_extraction?
    extraction_provider == 'mock'
  end
  
  # Get formatted confidence percentage
  def extraction_confidence_percent
    extraction_confidence ? "#{extraction_confidence.round(1)}%" : 'N/A'
  end
  
  # Validation Scopes
  scope :validation_pending, -> { where(validation_status: 'pending') }
  scope :validation_in_progress, -> { where(validation_status: 'in_progress') }
  scope :validated, -> { where(validation_status: 'validated') }
  scope :needs_validation, -> { extraction_completed.where(validation_status: ['pending', nil]) }
  
  # Validation helper methods
  def validation_pending?
    validation_status == 'pending' || validation_status.nil?
  end
  
  def validation_in_progress?
    validation_status == 'in_progress'
  end
  
  def validated?
    validation_status == 'validated'
  end
  
  def needs_validation?
    extraction_completed? && (validation_status.nil? || validation_status == 'pending')
  end
  
  def validation_status_badge_color
    case validation_status
    when 'validated' then 'green'
    when 'in_progress' then 'blue'
    when 'pending' then 'yellow'
    else 'gray'
    end
  end
  
  def validation_status_display
    case validation_status
    when 'validated' then 'Validé'
    when 'in_progress' then 'En cours'
    when 'pending' then 'En attente'
    else 'Non validé'
    end
  end
  
  # Track which fields were manually corrected during validation
  def mark_field_as_corrected(field_name)
    self.corrected_fields ||= {}
    self.corrected_fields[field_name] = true
  end
  
  def field_corrected?(field_name)
    corrected_fields&.key?(field_name.to_s)
  end
  
  # Get LLM extracted value for a specific field
  def extracted_value(field_name)
    return nil unless extraction_data.present?
    extraction_data[field_name.to_s] || extraction_data[field_name.to_sym]
  end
  
  # Get original (current) value for a specific field
  def original_value(field_name)
    send(field_name)
  end
  
  # Check if field has LLM extracted value
  def has_extracted_value?(field_name)
    extracted_value(field_name).present? 
  end
  
  # List of all validatable fields (grouped by category)
  def self.validation_fields
    {
      identification: [
        :title, :contract_type, :purchase_subfamily, :contract_object,
        :detailed_description, :contracting_method, :public_reference
      ],
      stakeholders: [
        :contractor_organization_name, :contractor_contact_name, :contractor_agency_name,
        :client_organization_name, :client_contact_name, :managing_department,
        :monitoring_manager, :contractor_phone, :contractor_email, :client_contact_email
      ],
      scope: [
        :equipment_count, :geographic_areas, :building_names, :floor_levels,
        :specific_zones, :technical_lot, :equipment_categories, :coverage_description
      ],
      financial: [
        :annual_amount_ht, :annual_amount_ttc, :monthly_amount, :billing_method,
        :billing_frequency, :payment_terms, :revision_conditions, :revision_index,
        :revision_frequency, :budget_code
      ],
      temporality: [
        :signature_date, :execution_start_date, :initial_duration_months,
        :renewal_duration_months, :renewal_count, :automatic_renewal,
        :notice_period_days, :next_deadline_date
      ],
      services: [
        :service_nature, :intervention_frequency, :intervention_delay_hours,
        :resolution_delay_hours, :working_hours, :on_call_24_7,
        :sla_percentage, :spare_parts_included
      ]
    }
  end
  
  # Apply validated data from extraction_data to main fields
  def apply_validation!(validated_params, user)
    update_attributes = {}
    corrected = {}
    
    # For each field in validated_params, determine source and update
    self.class.validation_fields.values.flatten.each do |field|
      next unless validated_params.key?(field.to_s)
      
      validated_value = validated_params[field.to_s]
      original = original_value(field)
      extracted = extracted_value(field)
      
      # Skip if no change
      next if validated_value == original
      
      # Track the source of the value
      if validated_value == extracted
        corrected[field.to_s] = 'llm_accepted'
      elsif validated_value != original
        corrected[field.to_s] = 'manual_edit'
      end
      
      update_attributes[field] = validated_value
    end
    
    # Update contract with validated data
    update_attributes.merge!(
      validation_status: 'validated',
      validated_at: Time.current,
      validated_by: user.email,
      validation_notes: validated_params[:validation_notes],
      corrected_fields: self.corrected_fields.merge(corrected)
    )
    
    update!(update_attributes)
  end
  
  # VAT Calculation Methods
  
  # Calculate TTC (inclusive) from HT (exclusive) amount
  def calculate_amount_ttc_from_ht
    return nil unless annual_amount_ht && vat_rate
    (annual_amount_ht * (1 + vat_rate / 100.0)).round(2)
  end
  
  # Calculate HT (exclusive) from TTC (inclusive) amount
  def calculate_amount_ht_from_ttc
    return nil unless annual_amount_ttc && vat_rate
    (annual_amount_ttc / (1 + vat_rate / 100.0)).round(2)
  end
  
  # Calculate monthly amount from annual TTC
  def calculate_monthly_from_annual
    return nil unless annual_amount_ttc
    (annual_amount_ttc / 12.0).round(2)
  end
  
  # Check if VAT calculation inputs have changed
  def vat_calculation_inputs_changed?
    vat_rate_changed? ||
    annual_amount_ht_changed? ||
    annual_amount_ttc_changed?
  end
  
  # Contract Date Calculation Methods
  
  # Calculate the contract end date based on start date, initial duration, and renewals
  def calculate_end_date
    return nil unless execution_start_date && initial_duration_months
    
    total_months = initial_duration_months.to_i
    
    # Add renewal periods if any
    if renewal_count.to_i > 0 && renewal_duration_months.to_i > 0
      total_months += (renewal_count.to_i * renewal_duration_months.to_i)
    end
    
    execution_start_date + total_months.months
  end
  
  # Calculate the last renewal date (when the last renewal period started)
  def calculate_last_renewal_date
    return nil unless execution_start_date && initial_duration_months
    return nil if renewal_count.to_i == 0 || renewal_duration_months.to_i == 0
    
    months_until_last_renewal = initial_duration_months.to_i + 
                                 ((renewal_count.to_i - 1) * renewal_duration_months.to_i)
    
    execution_start_date + months_until_last_renewal.months
  end
  
  # Calculate the termination notice deadline
  def calculate_termination_deadline
    calculated_end_date = calculate_end_date
    return nil unless calculated_end_date && notice_period_days.to_i > 0
    
    calculated_end_date - notice_period_days.to_i.days
  end
  
  # Update all calculated date fields
  def update_calculated_dates
    self.end_date = calculate_end_date
    self.last_renewal_date = calculate_last_renewal_date
    self.next_deadline_date = calculate_termination_deadline
  end
  
  # Check if date calculation inputs have changed
  def date_calculation_inputs_changed?
    execution_start_date_changed? ||
    initial_duration_months_changed? ||
    renewal_duration_months_changed? ||
    renewal_count_changed? ||
    notice_period_days_changed?
  end
  
  # Check if amount fields have changed
  def amount_fields_changed?
    annual_amount_ht_changed? || 
    annual_amount_ttc_changed? ||
    monthly_amount_changed?
  end

  private
  
  # Callback to automatically calculate contract dates before saving
  def calculate_contract_dates
    # Only recalculate if relevant fields have changed or if dates are nil
    if date_calculation_inputs_changed? || end_date.nil? || last_renewal_date.nil? || next_deadline_date.nil?
      update_calculated_dates
    end
  end
  
  # Callback to automatically calculate VAT amounts before saving
  def calculate_vat_amounts
    return unless vat_rate.present?
    
    # Determine which field changed to decide calculation direction
    # Priority: if HT changed and TTC didn't, calculate TTC from HT
    if annual_amount_ht_changed? && !annual_amount_ttc_changed?
      self.annual_amount_ttc = calculate_amount_ttc_from_ht
    # If TTC changed and HT didn't, calculate HT from TTC
    elsif annual_amount_ttc_changed? && !annual_amount_ht_changed?
      self.annual_amount_ht = calculate_amount_ht_from_ttc
    # If VAT rate changed, recalculate TTC from HT (HT is the base)
    elsif vat_rate_changed? && annual_amount_ht.present?
      self.annual_amount_ttc = calculate_amount_ttc_from_ht
    end
    
    # Always recalculate monthly from annual TTC if TTC is present
    if annual_amount_ttc.present?
      self.monthly_amount = calculate_monthly_from_annual
    end
  end
  
  # Callback to track when amounts are updated
  def track_amount_updates
    if amount_fields_changed?
      self.last_amount_update = Date.current
    end
  end
  
  # Callback to sync organization name fields when organization is linked
  def sync_organization_names
    if contractor_organization_id_changed? && contractor_organization.present?
      self.contractor_organization_name = contractor_organization.name
    end
    
    if client_organization_id_changed? && client_organization.present?
      self.client_organization_name = client_organization.name
    end
  end

  # Callback to reset extraction data when PDF is replaced
  def reset_extraction_on_pdf_change
    # Check if PDF attachment has changed
    if pdf_document.attached? && will_save_change_to_attribute?(:id) == false
      # This is an update (not create) - check if PDF changed by comparing blob IDs
      # ActiveStorage doesn't provide a clean "changed?" method, so we check the attachment record
      if pdf_document.attachment&.blob_id_previously_changed? || 
         (pdf_document.attachment&.new_record? && persisted?)
        # PDF was replaced - reset all extraction data
        Rails.logger.info("PDF replaced for contract #{id} - resetting extraction data")
        
        self.ocr_status = 'pending'
        self.ocr_text = nil
        self.ocr_error_message = nil
        self.ocr_processed_at = nil
        self.ocr_page_count = nil
        
        self.extraction_status = nil
        self.extraction_data = nil
        self.extraction_notes = nil
        self.extraction_confidence = nil
        self.extraction_processed_at = nil
        
        self.validation_status = nil
        self.validated_at = nil
        self.validated_by = nil
        self.corrected_fields = nil
      end
    end
  end
  
  # Check if PDF has been attached or changed
  def pdf_changed?
    return false unless pdf_document.attached?
    
    # On new record, if PDF is attached, it's "changed"
    return true if new_record?
    
    # On existing record, check if the blob has changed
    pdf_document.attachment&.blob_id_previously_changed? || false
  end

  # Determine if OCR extraction should be triggered
  def should_trigger_ocr?
    # Trigger OCR if:
    # 1. PDF is attached
    # 2. OCR status is pending (including after PDF replacement)
    # 3. This is a new record OR PDF was just changed
    pdf_attached? && 
      ocr_status == 'pending' &&
      (saved_change_to_attribute?(:id) || saved_change_to_ocr_status?)
  end

  # Trigger OCR extraction job
  def trigger_ocr_extraction
    ExtractContractOcrJob.perform_later(id)
  end
  
  # Determine if LLM extraction should be triggered
  def should_trigger_llm?
    # Trigger LLM if:
    # 1. OCR just completed (status changed to completed)
    # 2. Extraction hasn't been done yet or failed
    saved_change_to_ocr_status? &&
      ocr_status == 'completed' &&
      (extraction_status.nil? || extraction_status == 'pending' || extraction_status == 'failed')
  end
  
  # Trigger LLM extraction job
  def trigger_llm_extraction
    update_column(:extraction_status, 'pending') if extraction_status.nil?
    ExtractContractDataJob.perform_later(id)
  end

  def pdf_document_validation
    # Validate content type
    unless pdf_document.content_type == 'application/pdf'
      errors.add(:pdf_document, 'doit être un fichier PDF')
    end

    # Validate file size (max 10MB)
    if pdf_document.byte_size > 10.megabytes
      errors.add(:pdf_document, 'ne doit pas dépasser 10 Mo')
    end
  end
end
