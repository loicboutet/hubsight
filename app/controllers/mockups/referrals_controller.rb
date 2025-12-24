class Mockups::ReferralsController < ApplicationController
  def index
    # Load user's referrals
    @referrals = [] # TODO: Add referral model and query
  end

  def create
    # Send referral email
    # TODO: Implement email sending logic
    
    redirect_to referrals_path, notice: "Invitation envoyée avec succès."
  end
end
