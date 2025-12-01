module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :require_admin!
  end

  private

  def require_admin!
    unless current_user&.admin?
      # Log unauthorized access attempt
      Rails.logger.warn("Unauthorized admin access attempt by user #{current_user&.id || 'anonymous'} from IP #{request.remote_ip}")
      
      redirect_to root_path, alert: "Accès non autorisé. Seuls les administrateurs peuvent accéder à cette section."
    end
  end
end
