class Agency < ApplicationRecord
  # Associations
  belongs_to :organization

  # Constants
  AGENCY_TYPES = [
    ['Siège social', 'headquarters'],
    ['Agence régionale', 'regional_office'],
    ['Agence locale', 'branch'],
    ['Centre de service', 'service_center'],
    ['Dépôt', 'depot'],
    ['Autre', 'other']
  ].freeze

  # Validations
  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :code, uniqueness: { scope: :organization_id, allow_blank: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) if org_id.present? }
  scope :by_type, ->(type) { where(agency_type: type) if type.present? }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :search, ->(query) {
    where("name ILIKE ? OR city ILIKE ? OR code ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
  }
  scope :ordered, -> { order(:name) }

  # Instance methods
  def active?
    status == 'active'
  end

  def inactive?
    status == 'inactive'
  end

  def display_name
    code.present? ? "#{code} - #{name}" : name
  end

  def type_label
    AGENCY_TYPES.find { |label, value| value == agency_type }&.first || agency_type
  end

  def full_address
    [address, postal_code, city, region].compact.reject(&:blank?).join(', ')
  end
end
