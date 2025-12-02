module Admin
  class ClientsController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :require_admin!
    
    # GET /admin/clients
    def index
      @organizations = Organization.includes(:users)
                                   .order(created_at: :desc)
                                   .page(params[:page])
      
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
  end
end
