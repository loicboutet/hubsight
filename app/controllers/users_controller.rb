class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_portfolio_manager!, except: [:edit_profile, :update_profile]

  def index
    # Portfolio managers see site managers of their organization
    @users = User.by_role(User::ROLES[:site_manager])
                .where(organization_id: current_user.organization_id)
                .order(created_at: :desc)
  end

  def show
  end

  def new
    @user = User.new(
      role: User::ROLES[:site_manager],
      organization_id: current_user.organization_id
    )
  end

  def create
    @user = User.new(user_params)
    @user.role = User::ROLES[:site_manager]
    @user.organization_id = current_user.organization_id
    
    # Generate a temporary password if not provided
    if params[:user][:password].blank?
      generated_password = SecureRandom.alphanumeric(12)
      @user.password = generated_password
      @user.password_confirmation = generated_password
    end
    
    if @user.save
      # TODO: Send email with login credentials
      redirect_to users_path, notice: "Responsable de site créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    update_params = user_params
    
    # Remove password params if blank
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end
    
    # Ensure organization_id cannot be changed
    update_params.delete(:organization_id)
    
    if @user.update(update_params)
      redirect_to users_path, notice: "Responsable de site mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "Responsable de site supprimé avec succès."
  end

  # Profile Management Actions
  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    
    # Build notification preferences hash if provided
    if params[:user][:notification_preferences].present?
      notification_prefs = {
        email_alerts: params[:user][:notification_preferences][:email_alerts] == '1',
        email_upcoming: params[:user][:notification_preferences][:email_upcoming] == '1',
        email_at_risk: params[:user][:notification_preferences][:email_at_risk] == '1',
        email_missing_contracts: params[:user][:notification_preferences][:email_missing_contracts] == '1'
      }
      profile_params = profile_user_params
      profile_params[:notification_preferences] = notification_prefs
    else
      profile_params = profile_user_params
    end
    
    # Handle password update separately
    if profile_params[:password].present?
      # Require current password for password change
      if @user.valid_password?(params[:user][:current_password])
        if @user.update(profile_params)
          bypass_sign_in(@user) # Keep user signed in after password change
          redirect_to edit_profile_path, notice: "Profil mis à jour avec succès."
        else
          render :edit_profile, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "est incorrect")
        render :edit_profile, status: :unprocessable_entity
      end
    else
      # Update without password change
      profile_params.delete(:password)
      profile_params.delete(:password_confirmation)
      profile_params.delete(:current_password)
      
      if @user.update(profile_params)
        redirect_to edit_profile_path, notice: "Profil mis à jour avec succès."
      else
        render :edit_profile, status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    @user = User.by_role(User::ROLES[:site_manager])
               .where(organization_id: current_user.organization_id)
               .find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email, 
      :first_name, 
      :last_name, 
      :phone, 
      :department,
      :status,
      :password,
      :password_confirmation
    )
  end
  
  def profile_user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :phone,
      :department,
      :language,
      :password,
      :password_confirmation,
      :current_password
    )
  end
  
  def ensure_portfolio_manager!
    # TODO: Implement proper authorization
    # For now, just a placeholder
    # redirect_to root_path, alert: "Accès non autorisé" unless current_user&.portfolio_manager?
  end
end
