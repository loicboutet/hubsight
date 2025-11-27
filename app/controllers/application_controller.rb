class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
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
    dashboard_path
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
