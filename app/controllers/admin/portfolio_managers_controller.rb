module Admin
  class PortfolioManagersController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :set_portfolio_manager, only: [:show, :edit, :update, :destroy, :resend_invitation]
    
    # GET /admin/portfolio_managers
    def index
      @portfolio_managers = User.by_role(User::ROLES[:portfolio_manager])
                                .includes(:organization)
      
      # Search filter
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @portfolio_managers = @portfolio_managers.where(
          "LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)",
          search_term, search_term, search_term
        )
      end
      
      # Status filter
      if params[:status].present? && params[:status] != 'all'
        @portfolio_managers = @portfolio_managers.where(status: params[:status])
      end
      
      # Invitation status filter
      if params[:invitation_status].present? && params[:invitation_status] != 'all'
        case params[:invitation_status]
        when 'pending'
          @portfolio_managers = @portfolio_managers.where.not(invitation_token: nil).where(invitation_accepted_at: nil)
        when 'accepted'
          @portfolio_managers = @portfolio_managers.where.not(invitation_accepted_at: nil)
        when 'expired'
          @portfolio_managers = @portfolio_managers.where("invitation_sent_at < ?", 7.days.ago)
                                                   .where(invitation_accepted_at: nil)
                                                   .where.not(invitation_token: nil)
        end
      end
      
      @portfolio_managers = @portfolio_managers.order(created_at: :desc)
                                               .page(params[:page])
                                               .per(25)
    end
    
    # GET /admin/portfolio_managers/:id
    def show
    end
    
    # GET /admin/portfolio_managers/new
    def new
      @portfolio_manager = User.new(role: User::ROLES[:portfolio_manager])
      @organizations = Organization.active.order(:name)
    end
    
    # POST /admin/portfolio_managers
    def create
      # Validate organization first
      if portfolio_manager_params[:organization_id].present?
        organization = Organization.find_by(id: portfolio_manager_params[:organization_id])
        
        unless organization
          @portfolio_manager = User.new(portfolio_manager_params)
          @portfolio_manager.role = User::ROLES[:portfolio_manager]
          @organizations = Organization.active.order(:name)
          flash.now[:alert] = "L'organisation sélectionnée n'existe pas."
          render :new, status: :unprocessable_entity
          return
        end
        
        unless organization.active?
          @portfolio_manager = User.new(portfolio_manager_params)
          @portfolio_manager.role = User::ROLES[:portfolio_manager]
          @organizations = Organization.active.order(:name)
          flash.now[:alert] = "L'organisation sélectionnée est inactive."
          render :new, status: :unprocessable_entity
          return
        end
      end
      
      @portfolio_manager = User.new(portfolio_manager_params)
      @portfolio_manager.role = User::ROLES[:portfolio_manager]
      @portfolio_manager.invited_by = current_user
      @portfolio_manager.status = 'active'
      
      # Skip password validation - user will set it via invitation
      @portfolio_manager.password = SecureRandom.hex(20)
      @portfolio_manager.password_confirmation = @portfolio_manager.password
      
      ActiveRecord::Base.transaction do
        if @portfolio_manager.save(validate: false)
          # Generate invitation token and send email
          @portfolio_manager.generate_invitation_token!
          @portfolio_manager.send_invitation_email
          
          redirect_to admin_portfolio_managers_path, 
                      notice: "Gestionnaire de portefeuille créé avec succès. Invitation envoyée à #{@portfolio_manager.email}."
        else
          @organizations = Organization.active.order(:name)
          render :new, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      @organizations = Organization.active.order(:name)
      flash.now[:alert] = "Erreur lors de la création: #{e.message}"
      render :new, status: :unprocessable_entity
    end
    
    # GET /admin/portfolio_managers/:id/edit
    def edit
      @organizations = Organization.active.order(:name)
    end
    
    # PATCH/PUT /admin/portfolio_managers/:id
    def update
      update_params = portfolio_manager_params
      
      # Validate organization if being changed
      if update_params[:organization_id].present?
        organization = Organization.find_by(id: update_params[:organization_id])
        
        unless organization&.active?
          @organizations = Organization.active.order(:name)
          flash.now[:alert] = "L'organisation sélectionnée n'est pas valide ou est inactive."
          render :edit, status: :unprocessable_entity
          return
        end
      end
      
      # Remove password params if blank
      if update_params[:password].blank?
        update_params.delete(:password)
        update_params.delete(:password_confirmation)
      end
      
      if @portfolio_manager.update(update_params)
        redirect_to admin_portfolio_managers_path, 
                    notice: "Gestionnaire de portefeuille mis à jour avec succès."
      else
        @organizations = Organization.active.order(:name)
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      @organizations = Organization.active.order(:name)
      flash.now[:alert] = "Erreur lors de la mise à jour: #{e.message}"
      render :edit, status: :unprocessable_entity
    end
    
    # DELETE /admin/portfolio_managers/:id
    def destroy
      @portfolio_manager.destroy
      redirect_to admin_portfolio_managers_path, 
                  notice: "Gestionnaire de portefeuille supprimé avec succès."
    end
    
    # POST /admin/portfolio_managers/:id/resend_invitation
    def resend_invitation
      if @portfolio_manager.invitation_pending?
        # Generate new invitation token and resend email
        @portfolio_manager.generate_invitation_token!
        @portfolio_manager.send_invitation_email
        
        # Log for audit trail (Phase 4 - Item 9)
        Rails.logger.info("Admin #{current_user.email} resent invitation to: #{@portfolio_manager.email}")
        
        redirect_to admin_portfolio_manager_path(@portfolio_manager), 
                    notice: "Invitation renvoyée avec succès à #{@portfolio_manager.email}."
      else
        redirect_to admin_portfolio_manager_path(@portfolio_manager), 
                    alert: "Cette invitation a déjà été acceptée."
      end
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
  end
end
