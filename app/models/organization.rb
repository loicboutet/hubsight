class Organization < ApplicationRecord
  # Associations
  has_many :users, dependent: :restrict_with_error
  has_many :sites, dependent: :restrict_with_error
  has_many :buildings, dependent: :restrict_with_error
  has_many :levels, dependent: :restrict_with_error
  has_many :spaces, dependent: :restrict_with_error
  has_many :equipment, dependent: :restrict_with_error
  has_many :contacts, dependent: :destroy
  has_many :agencies, dependent: :destroy

  # Constants
  ORGANIZATION_TYPES = [
    ['Prestataire', 'service_provider'],
    ['Fournisseur', 'supplier'],
    ['Locataire', 'tenant'],
    ['Propriétaire', 'owner'],
    ['Autre', 'other']
  ].freeze

  # Callbacks
  before_validation :normalize_siret

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :organization_type, presence: true
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :siret, format: { with: /\A\d{14}\z/, message: "doit contenir exactement 14 chiffres" }, allow_blank: true

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_type, ->(type) { where(organization_type: type) if type.present? }
  scope :search, ->(query) {
    where("name ILIKE ? OR legal_name ILIKE ? OR siret ILIKE ?", 
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
    legal_name.present? ? "#{name} (#{legal_name})" : name
  end

  def type_label
    ORGANIZATION_TYPES.find { |label, value| value == organization_type }&.first || organization_type
  end

  def formatted_siret
    return nil if siret.blank?
    siret.scan(/.{1,3}/).join(' ')
  end

  def full_address
    [headquarters_address, postal_code, city].compact.join(', ')
  end

  private

  # Normalize SIRET before validation
  # Strips whitespace and removes formatting characters (spaces, dashes, etc.)
  # Converts empty strings to nil so allow_blank: true works correctly
  def normalize_siret
    return if siret.nil?
    
    # Remove all whitespace and formatting characters
    normalized = siret.to_s.gsub(/[\s\-\.]/, '')
    
    # Convert empty string to nil
    self.siret = normalized.present? ? normalized : nil
  end
end
