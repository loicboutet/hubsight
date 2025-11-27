class SessionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @sessions = current_user.active_sessions.order(created_at: :desc)
  end

  def destroy
    session = current_user.active_sessions.find(params[:id])
    
    if session.id == current_active_session&.id
      redirect_to sessions_path, alert: "Vous ne pouvez pas terminer votre session actuelle. Utilisez la déconnexion à la place."
    else
      session.destroy
      redirect_to sessions_path, notice: "Session terminée avec succès."
    end
  end

  private

  def current_active_session
    @current_active_session ||= current_user.active_sessions.find_by(
      user_agent: request.user_agent,
      ip_address: request.remote_ip
    )
  end
end
