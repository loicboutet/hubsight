module PortfolioManagerAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :require_portfolio_manager!
  end

  private

  def require_portfolio_manager!
    unless current_user&.portfolio_manager? || current_user&.admin?
      # Log unauthorized access attempt
      Rails.logger.warn("Unauthorized portfolio manager access attempt by user #{current_user&.id || 'anonymous'} from IP #{request.remote_ip}")
      
      redirect_to root_path, alert: "Accès non autorisé. Seuls les gestionnaires de portefeuille peuvent accéder à cette section."
    end
  end
end
