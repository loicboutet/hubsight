class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  # Roles based on specifications
  ROLES = {
    admin: 'admin',
    portfolio_manager: 'portfolio_manager',
    site_manager: 'site_manager',
    technician: 'technician'
  }.freeze

  # Associations
  has_many :active_sessions, dependent: :destroy
  has_many :sites, dependent: :destroy
  has_many :site_assignments, dependent: :destroy
  has_many :assigned_sites, through: :site_assignments, source: :site
  belongs_to :invited_by, class_name: 'User', optional: true
  belongs_to :organization, optional: true

  # Validations
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: ROLES.values }
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :status, inclusion: { in: %w[active inactive] }, allow_nil: true
  validates :language, inclusion: { in: %w[fr en] }, allow_nil: true
  validates :password, password_strength: true, if: :password_required?

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_role, ->(role) { where(role: role) }
  scope :by_organization, ->(organization_id) { where(organization_id: organization_id) }

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

  # Invitation methods
  def generate_invitation_token!
    self.invitation_token = SecureRandom.urlsafe_base64(32)
    self.invitation_created_at = Time.current
    save(validate: false)
  end

  def send_invitation_email
    self.invitation_sent_at = Time.current
    save(validate: false)
    UserMailer.invitation_instructions(self).deliver_later
  end

  def accept_invitation!(params)
    self.invitation_accepted_at = Time.current
    self.password = params[:password]
    self.password_confirmation = params[:password_confirmation]
    self.invitation_token = nil
    save
  end

  def invitation_pending?
    invitation_token.present? && invitation_accepted_at.nil?
  end

  def invitation_expired?
    return false unless invitation_pending?
    invitation_created_at < 7.days.ago
  end

  # Override Devise confirmable to skip confirmation for invited users
  def confirmation_required?
    !invitation_pending? && super
  end

  # Prevent login until invitation is accepted
  def active_for_authentication?
    super && !invitation_pending?
  end

  # Custom message for pending invitations
  def inactive_message
    invitation_pending? ? :invitation_pending : super
  end
end
