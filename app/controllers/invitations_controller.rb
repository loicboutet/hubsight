class InvitationsController < ApplicationController
  skip_before_action :authenticate_user!
  
  def show
    @user = User.find_by(invitation_token: params[:token])
    
    if @user.nil?
      redirect_to root_path, alert: "Invitation invalide."
    elsif @user.invitation_expired?
      redirect_to root_path, alert: "Cette invitation a expiré. Veuillez contacter votre administrateur."
    elsif @user.invitation_accepted_at.present?
      redirect_to root_path, alert: "Cette invitation a déjà été utilisée."
    end
  end
  
  def update
    @user = User.find_by(invitation_token: params[:token])
    
    if @user.nil?
      redirect_to root_path, alert: "Invitation invalide."
      return
    end
    
    if @user.invitation_expired?
      redirect_to root_path, alert: "Cette invitation a expiré."
      return
    end
    
    if @user.accept_invitation!(invitation_params)
      # Confirm the email automatically when accepting invitation
      @user.confirm if @user.respond_to?(:confirm)
      
      sign_in(@user)
      redirect_to dashboard_path, notice: "Bienvenue sur HubSight ! Votre compte a été activé avec succès."
    else
      render :show
    end
  end
  
  private
  
  def invitation_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
