class Contract < ApplicationRecord
  belongs_to :organization
  belongs_to :site, optional: true

  # Validations
  validates :organization_id, presence: true
  validates :status, inclusion: { in: %w[active expired pending suspended] }
  validates :annual_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_family, ->(family) { where(contract_family: family) }
  scope :by_status, ->(status) { where(status: status) }
  scope :in_date_range, ->(start_date, end_date) { where('start_date >= ? AND start_date <= ?', start_date, end_date) }

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
end
