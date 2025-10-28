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
  
  # TODO: PHASE 2 - Replace URL parameter with actual user authentication
  # This method currently checks ?role=admin parameter or admin namespace
  # Later: Replace with current_user.admin? or similar authorization check
  def admin_context?
    params[:role] == 'admin' || self.class.module_parent == Admin
  end
  
  # Make admin_context? available in views
  helper_method :admin_context?
  
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
