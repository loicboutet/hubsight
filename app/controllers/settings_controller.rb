class SettingsController < ApplicationController
  def index
    # current_user already available from ApplicationController
  end

  def update
    if password_update_requested?
      update_password
    else
      update_profile
    end
  end

  private

  def password_update_requested?
    params[:user][:password].present? || params[:user][:current_password].present?
  end

  def update_password
    # Verify current password first
    unless current_user.valid_password?(params[:user][:current_password])
      flash.now[:alert] = "Le mot de passe actuel est incorrect."
      render :index, status: :unprocessable_entity
      return
    end

    # Update password
    if current_user.update(user_params_with_password.except(:current_password))
      bypass_sign_in(current_user) # Re-authenticate user after password change
      flash[:notice] = "Mot de passe mis à jour avec succès."
      redirect_to settings_path
    else
      flash.now[:alert] = current_user.errors.full_messages.join(", ")
      render :index, status: :unprocessable_entity
    end
  end

  def update_profile
    if current_user.update(user_params)
      flash[:notice] = "Profil mis à jour avec succès."
      redirect_to settings_path
    else
      flash.now[:alert] = current_user.errors.full_messages.join(", ")
      render :index, status: :unprocessable_entity
    end
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  def user_params_with_password
    params.require(:user).permit(:first_name, :last_name, :email, :phone, 
                                 :current_password, :password, :password_confirmation)
  end
end
