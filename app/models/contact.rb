class Contact < ApplicationRecord
  # Associations
  belongs_to :organization

  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :email, uniqueness: { scope: :organization_id, allow_blank: true }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) if org_id.present? }
  scope :search, ->(query) {
    where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ? OR position ILIKE ?",
          "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%") if query.present?
  }
  scope :ordered, -> { order(:last_name, :first_name) }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}".strip
  end

  def display_name
    position.present? ? "#{full_name} - #{position}" : full_name
  end

  def active?
    status == 'active'
  end

  def inactive?
    status == 'inactive'
  end
end
