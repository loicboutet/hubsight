class ApplicationController < ActionController::Base
  # Include impersonation functionality
  include Impersonation
  
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Session tracking
  before_action :track_session
  
  # Use user layout for all controllers by default
  # Admin controllers will override this with their own layout
  layout :layout_by_resource
  
  private
  
  def layout_by_resource
    if devise_controller?
      'auth'
    elsif admin_context?
      'admin'
    else
      'user'
    end
  end
  
  # Check if current context should use admin layout
  # Returns true only if current user has admin role
  # This ensures:
  # - admin@hubsight.com (admin role) → admin layout
  # - portfolio@hubsight.com (portfolio_manager role) → user layout
  # - sitemanager@hubsight.com (site_manager role) → user layout
  def admin_context?
    current_user&.admin?
  end
  
  # Make admin_context? available in views
  helper_method :admin_context?
  
  # Redirect to dashboard after successful login
  def after_sign_in_path_for(resource)
    create_active_session
    dashboard_path
  end
  
  # Track active sessions
  def track_session
    return unless user_signed_in?
    
    # Find or create active session for this device/IP
    @current_active_session ||= current_user.active_sessions.find_or_create_by(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    ) do |session|
      session.created_at = Time.current
    end
    
    # Update last activity
    @current_active_session.update(updated_at: Time.current)
  end
  
  def create_active_session
    return unless user_signed_in?
    
    ActiveSession.create(
      user: current_user,
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    )
  end
  
  # TODO: PHASE 2 - Add authorization checks
  # Add methods like:
  # def authorize_admin!
  #   redirect_to root_path unless current_user&.admin?
  # end
  # 
  # def authorize_portfolio_manager!
  #   redirect_to root_path unless current_user&.portfolio_manager?
  # end
end
