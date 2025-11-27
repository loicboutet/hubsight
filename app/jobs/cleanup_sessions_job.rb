class CleanupSessionsJob < ApplicationJob
  queue_as :default

  def perform
    # Remove sessions that haven't been active for more than 30 minutes
    # (matching Devise's timeout_in configuration)
    timeout_threshold = 30.minutes.ago
    
    expired_sessions = ActiveSession.where("updated_at < ?", timeout_threshold)
    count = expired_sessions.count
    
    expired_sessions.destroy_all
    
    Rails.logger.info "CleanupSessionsJob: Removed #{count} expired sessions"
  end
end
