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
end
