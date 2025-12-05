module Admin
  class UsersController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :set_user, only: [:show, :edit, :update, :destroy, :resend_invitation]
    
    # GET /admin/users
    def index
      @users = User.includes(:organization)
      
      # Role filter
      if params[:role].present? && params[:role] != 'all'
        @users = @users.by_role(params[:role])
      end
      
      # Search filter
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @users = @users.where(
          "LOWER(first_name) LIKE LOWER(?) OR LOWER(last_name) LIKE LOWER(?) OR LOWER(email) LIKE LOWER(?)",
          search_term, search_term, search_term
        )
      end
      
      # Status filter
      if params[:status].present? && params[:status] != 'all'
        @users = @users.where(status: params[:status])
      end
      
      # Invitation status filter
      if params[:invitation_status].present? && params[:invitation_status] != 'all'
        case params[:invitation_status]
        when 'pending'
          @users = @users.where.not(invitation_token: nil).where(invitation_accepted_at: nil)
        when 'accepted'
          @users = @users.where.not(invitation_accepted_at: nil)
        when 'expired'
          @users = @users.where("invitation_sent_at < ?", 7.days.ago)
                         .where(invitation_accepted_at: nil)
                         .where.not(invitation_token: nil)
        end
      end
      
      @users = @users.order(created_at: :desc)
                    .page(params[:page])
                    .per(25)
    end
    
    # GET /admin/users/:id
    def show
    end
    
    # GET /admin/users/:id/edit
    def edit
      @organizations = Organization.active.order(:name)
    end
    
    # PATCH/PUT /admin/users/:id
    def update
      update_params = user_params
      
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
      
      if @user.update(update_params)
        redirect_to admin_users_path, 
                    notice: "Utilisateur mis à jour avec succès."
      else
        @organizations = Organization.active.order(:name)
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      @organizations = Organization.active.order(:name)
      flash.now[:alert] = "Erreur lors de la mise à jour: #{e.message}"
      render :edit, status: :unprocessable_entity
    end
    
    # DELETE /admin/users/:id
    def destroy
      @user.destroy
      redirect_to admin_users_path, 
                  notice: "Utilisateur supprimé avec succès."
    end
    
    # POST /admin/users/:id/resend_invitation
    def resend_invitation
      if @user.invitation_pending?
        # Generate new invitation token and resend email
        @user.generate_invitation_token!
        @user.send_invitation_email
        
        # Log for audit trail
        Rails.logger.info("Admin #{current_user.email} resent invitation to: #{@user.email}")
        
        redirect_to admin_user_path(@user), 
                    notice: "Invitation renvoyée avec succès à #{@user.email}."
      else
        redirect_to admin_user_path(@user), 
                    alert: "Cette invitation a déjà été acceptée."
      end
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(
        :email, 
        :first_name, 
        :last_name, 
        :phone, 
        :department,
        :organization_id,
        :role,
        :status,
        :password,
        :password_confirmation
      )
    end
  end
end
