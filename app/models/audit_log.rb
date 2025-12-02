class AuditLog < ApplicationRecord
  belongs_to :user

  # Validations
  validates :action, presence: true
  validates :auditable_type, presence: true

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_action, ->(action) { where(action: action) }
  scope :successful, -> { where(status: 'success') }
  scope :failed, -> { where(status: 'failed') }
  scope :for_auditable, ->(type, id) { where(auditable_type: type, auditable_id: id) }

  # Actions constants
  ACTIONS = {
    create: 'create',
    update: 'update',
    delete: 'delete',
    view: 'view',
    export: 'export',
    import: 'import'
  }.freeze

  # Class method to log an action
  def self.log_action(user:, action:, auditable_type:, auditable_id: nil, change_data: {}, metadata: {}, ip_address: nil, user_agent: nil, status: 'success', error_message: nil)
    create(
      user: user,
      action: action,
      auditable_type: auditable_type,
      auditable_id: auditable_id,
      change_data: change_data,
      metadata: metadata,
      ip_address: ip_address,
      user_agent: user_agent,
      status: status,
      error_message: error_message
    )
  end

  # Instance methods
  def user_email
    user&.email || 'Unknown'
  end

  def auditable_name
    change_data&.dig('name') || "#{auditable_type} ##{auditable_id}"
  end
end
