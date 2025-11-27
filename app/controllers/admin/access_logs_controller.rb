module Admin
  class AccessLogsController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :require_admin

    # GET /admin/access_logs
    def index
      @access_logs = AdminAccessLog.includes(:admin_user, :organization)
                                    .recent
                                    .page(params[:page])
                                    .per(50)

      # Apply filters if provided
      if params[:admin_id].present?
        @access_logs = @access_logs.by_admin(params[:admin_id])
      end

      if params[:organization_id].present?
        @access_logs = @access_logs.by_organization(params[:organization_id])
      end

      if params[:action_type].present?
        @access_logs = @access_logs.by_action(params[:action_type])
      end

      if params[:status].present?
        case params[:status]
        when 'active'
          @access_logs = @access_logs.active
        when 'completed'
          @access_logs = @access_logs.completed
        end
      end

      # Get filter options
      @admin_users = User.where(role: 'admin').order(:email)
      @organizations = Organization.order(:name)
    end

    # GET /admin/access_logs/:id
    def show
      @access_log = AdminAccessLog.includes(:admin_user, :organization)
                                   .find(params[:id])
    end

    private

    def require_admin
      unless current_user&.admin?
        redirect_to root_path, alert: 'Accès non autorisé.'
      end
    end
  end
end
