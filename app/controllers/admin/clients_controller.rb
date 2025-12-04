module Admin
  class ClientsController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :require_admin!
    
    # GET /admin/clients
    def index
      @organizations = Organization.includes(:users)
      
      # Search filter
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @organizations = @organizations.where(
          "LOWER(name) LIKE LOWER(?) OR LOWER(legal_name) LIKE LOWER(?) OR LOWER(siret) LIKE LOWER(?)",
          search_term, search_term, search_term
        )
      end
      
      # Status filter
      if params[:status].present? && params[:status] != 'all'
        case params[:status]
        when 'active'
          @organizations = @organizations.where(status: 'active')
        when 'inactive'
          @organizations = @organizations.where.not(status: 'active')
        end
      end
      
      @organizations = @organizations.order(created_at: :desc)
                                   .page(params[:page])
                                   .per(15)
      
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
