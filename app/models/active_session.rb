class ActiveSession < ApplicationRecord
  belongs_to :user

  validates :session_id, presence: true, uniqueness: true

  # Scopes
  scope :active, -> { where('last_activity_at > ?', 30.minutes.ago) }
  scope :expired, -> { where('last_activity_at <= ?', 30.minutes.ago) }

  # Methods
  def self.cleanup_expired
    expired.destroy_all
  end

  def touch_activity
    update(last_activity_at: Time.current)
  end

  def active?
    last_activity_at && last_activity_at > 30.minutes.ago
  end
end
