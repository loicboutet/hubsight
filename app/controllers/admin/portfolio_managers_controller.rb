module Admin
  class PortfolioManagersController < ApplicationController
    layout 'admin'
    before_action :set_portfolio_manager, only: [:show, :edit, :update, :destroy]
    before_action :ensure_admin!
    
    # GET /admin/portfolio_managers
    def index
      @portfolio_managers = User.by_role(User::ROLES[:portfolio_manager])
                                .order(created_at: :desc)
    end
    
    # GET /admin/portfolio_managers/:id
    def show
    end
    
    # GET /admin/portfolio_managers/new
    def new
      @portfolio_manager = User.new(role: User::ROLES[:portfolio_manager])
    end
    
    # POST /admin/portfolio_managers
    def create
      @portfolio_manager = User.new(portfolio_manager_params)
      @portfolio_manager.role = User::ROLES[:portfolio_manager]
      
      # Generate a temporary password if not provided
      if params[:user][:password].blank?
        generated_password = SecureRandom.alphanumeric(12)
        @portfolio_manager.password = generated_password
        @portfolio_manager.password_confirmation = generated_password
      end
      
      if @portfolio_manager.save
        # TODO: Send email with login credentials
        redirect_to admin_portfolio_managers_path, 
                    notice: "Gestionnaire de portefeuille créé avec succès."
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    # GET /admin/portfolio_managers/:id/edit
    def edit
    end
    
    # PATCH/PUT /admin/portfolio_managers/:id
    def update
      update_params = portfolio_manager_params
      
      # Remove password params if blank
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end
      
      if @portfolio_manager.update(update_params)
        redirect_to admin_portfolio_managers_path, 
                    notice: "Gestionnaire de portefeuille mis à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    end
    
    # DELETE /admin/portfolio_managers/:id
    def destroy
      @portfolio_manager.destroy
      redirect_to admin_portfolio_managers_path, 
                  notice: "Gestionnaire de portefeuille supprimé avec succès."
    end
    
    private
    
    def set_portfolio_manager
      @portfolio_manager = User.by_role(User::ROLES[:portfolio_manager])
                              .find(params[:id])
    end
    
    def portfolio_manager_params
      params.require(:user).permit(
        :email, 
        :first_name, 
        :last_name, 
        :phone, 
        :department,
        :organization_id,
        :status,
        :password,
        :password_confirmation
      )
    end
    
    def ensure_admin!
      # TODO: Implement proper admin authorization
      # For now, just a placeholder
      # redirect_to root_path, alert: "Accès non autorisé" unless current_user&.admin?
    end
  end
end
