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
    else
      'user'
    end
  end
end
