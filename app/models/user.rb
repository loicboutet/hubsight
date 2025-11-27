class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # Roles based on specifications
  ROLES = {
    admin: 'admin',
    portfolio_manager: 'portfolio_manager',
    site_manager: 'site_manager',
    technician: 'technician'
  }.freeze

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES.values }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }, allow_nil: true

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_role, ->(role) { where(role: role) }

  # Role helper methods
  def admin?
    role == ROLES[:admin]
  end

  def portfolio_manager?
    role == ROLES[:portfolio_manager]
  end

  def site_manager?
    role == ROLES[:site_manager]
  end

  def technician?
    role == ROLES[:technician]
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def active?
    status == 'active'
  end
end
