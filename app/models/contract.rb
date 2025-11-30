class Contract < ApplicationRecord
  belongs_to :organization
  belongs_to :site, optional: true

  # ActiveStorage attachment for PDF document
  has_one_attached :pdf_document

  # Validations
  validates :organization_id, presence: true
  validates :status, inclusion: { in: %w[active expired pending suspended] }
  validates :annual_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :ocr_status, inclusion: { in: %w[pending processing completed failed] }, allow_nil: true
  
  # PDF validations
  validate :pdf_document_validation, if: -> { pdf_document.attached? }

  # Callbacks
  after_commit :trigger_ocr_extraction, on: [:create, :update], if: :should_trigger_ocr?

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_family, ->(family) { where(contract_family: family) }
  scope :by_status, ->(status) { where(status: status) }
  scope :in_date_range, ->(start_date, end_date) { where('start_date >= ? AND start_date <= ?', start_date, end_date) }
  
  # OCR Scopes
  scope :ocr_pending, -> { where(ocr_status: 'pending') }
  scope :ocr_processing, -> { where(ocr_status: 'processing') }
  scope :ocr_completed, -> { where(ocr_status: 'completed') }
  scope :ocr_failed, -> { where(ocr_status: 'failed') }

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

  private

  # Determine if OCR extraction should be triggered
  def should_trigger_ocr?
    # Trigger OCR if:
    # 1. PDF was just attached (saved_change_to_attribute?)
    # 2. OCR status is pending or nil
    # 3. PDF is actually attached
    pdf_attached? && 
      (ocr_status.nil? || ocr_status == 'pending') &&
      saved_change_to_attribute?(:id) # Only on create, or we can add PDF change detection
  end

  # Trigger OCR extraction job
  def trigger_ocr_extraction
    ExtractContractOcrJob.perform_later(id)
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
