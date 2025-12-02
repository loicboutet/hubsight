module Admin
  class SeedsController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :require_admin

    # GET /admin/seeds
    def index
      # Show the seed runner page
    end

    # POST /admin/seeds/run
    def run
      begin
        # Run the seed file
        Rails.application.load_seed
        
        flash[:notice] = "Database seeding completed successfully!"
      rescue => e
        flash[:alert] = "Error running database seed: #{e.message}"
        Rails.logger.error "Seed error: #{e.message}\n#{e.backtrace.join("\n")}"
      end
      
      redirect_to admin_seeds_path
    end

    private

    def require_admin
      unless current_user&.admin?
        redirect_to root_path, alert: 'Accès non autorisé.'
      end
    end
  end
end
