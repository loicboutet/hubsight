class Organization < ApplicationRecord
  # Associations
  has_many :users, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[active inactive] }

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }

  # Instance methods
  def active?
    status == 'active'
  end

  def inactive?
    status == 'inactive'
  end
end
