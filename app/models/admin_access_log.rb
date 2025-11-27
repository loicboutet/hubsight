class AdminAccessLog < ApplicationRecord
  # Associations
  belongs_to :admin_user, class_name: 'User'
  belongs_to :organization

  # Validations
  validates :admin_user_id, presence: true
  validates :organization_id, presence: true
  validates :action_type, presence: true, inclusion: { 
    in: %w[impersonate stop_impersonation data_view data_edit] 
  }
  validates :ip_address, presence: true
  validates :started_at, presence: true

  # Scopes
  scope :active, -> { where(ended_at: nil) }
  scope :completed, -> { where.not(ended_at: nil) }
  scope :by_admin, ->(admin_id) { where(admin_user_id: admin_id) }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_action, ->(action) { where(action_type: action) }
  scope :recent, -> { order(started_at: :desc) }

  # Instance methods
  def active?
    ended_at.nil?
  end

  def duration
    return nil unless ended_at
    ended_at - started_at
  end

  def duration_in_words
    return 'En cours' if active?
    return nil unless duration
    
    hours = (duration / 3600).to_i
    minutes = ((duration % 3600) / 60).to_i
    seconds = (duration % 60).to_i
    
    if hours > 0
      "#{hours}h #{minutes}min"
    elsif minutes > 0
      "#{minutes}min #{seconds}s"
    else
      "#{seconds}s"
    end
  end

  def self.log_impersonation_start(admin_user, organization, request)
    create!(
      admin_user: admin_user,
      organization: organization,
      action_type: 'impersonate',
      ip_address: request.remote_ip,
      user_agent: request.user_agent,
      started_at: Time.current,
      metadata: {
        admin_email: admin_user.email,
        organization_name: organization.name,
        request_path: request.path
      }
    )
  end

  def end_impersonation!
    update!(ended_at: Time.current)
  end
end
