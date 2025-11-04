class SettingsController < ApplicationController
  def index
    # Load current user settings
  end

  def update
    if current_user.update(user_params)
      redirect_to settings_path, notice: "Paramètres mis à jour avec succès."
    else
      render :index, alert: "Erreur lors de la mise à jour des paramètres."
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :language, :timezone, :date_format)
  end
end
