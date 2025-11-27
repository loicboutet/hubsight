class UserMailer < ApplicationMailer
  def invitation_instructions(user)
    @user = user
    @token = user.invitation_token
    @accept_url = accept_invitation_url(token: @token)
    @invited_by = user.invited_by
    
    mail(
      to: @user.email,
      subject: 'Invitation à rejoindre HubSight'
    )
  end
end
