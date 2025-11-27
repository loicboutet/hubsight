module Admin
  class ClientsController < ApplicationController
    include Impersonation
    include AdminAuthorization
    
    layout 'admin'
    before_action :require_admin_for_impersonation
    before_action :set_organization, only: [:impersonate]
    
    # GET /admin/clients
    def index
      @organizations = Organization.includes(:users)
                                   .order(created_at: :desc)
      
      # Get summary statistics for each organization
      @organization_stats = {}
      @organizations.each do |org|
        @organization_stats[org.id] = {
          portfolio_managers: org.users.where(role: 'portfolio_manager').count,
          site_managers: org.users.where(role: 'site_manager').count,
          total_users: org.users.count
        }
      end
    end
    
    # POST /admin/clients/:id/impersonate
    def impersonate
      if start_impersonation(@organization)
        redirect_to dashboard_path, notice: "Vous accédez maintenant aux données de #{@organization.name}. Toutes vos actions sont enregistrées."
      else
        redirect_to admin_clients_path, alert: 'Impossible de démarrer la session d\'accès client.'
      end
    end
    
    # POST /admin/stop_impersonation
    def stop_impersonation
      if stop_impersonation
        redirect_to admin_clients_path, notice: 'Session d\'accès client terminée.'
      else
        redirect_to root_path, alert: 'Aucune session d\'accès client active.'
      end
    end
    
    private
    
    def set_organization
      @organization = Organization.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_clients_path, alert: 'Organisation introuvable.'
    end
  end
end
