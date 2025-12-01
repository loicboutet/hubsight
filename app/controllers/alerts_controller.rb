class AlertsController < ApplicationController
  before_action :authenticate_user!

  def index
    # Calculate alerts from contracts
    # Admin sees all data, other users see only their organization's data
    if current_user&.admin?
      @total_contracts = Contract.where(status: 'active').count
      
      # Attention: Contracts expiring in 31-90 days
      @attention_count = Contract
        .where(status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today + 30.days, Date.today + 90.days)
        .count
      
      # Alert: Contracts expiring in 0-30 days  
      @alert_count = Contract
        .where(status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today, Date.today + 30.days)
        .count
      
      # Get contracts for display (ordered by urgency)
      @alerts = Contract
        .where(status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today, Date.today + 90.days)
        .order(:end_date)
        .includes(:site)
    elsif current_user&.organization_id
      @total_contracts = Contract.where(organization_id: current_user.organization_id, status: 'active').count
      
      # Attention: Contracts expiring in 31-90 days
      @attention_count = Contract
        .where(organization_id: current_user.organization_id, status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today + 30.days, Date.today + 90.days)
        .count
      
      # Alert: Contracts expiring in 0-30 days  
      @alert_count = Contract
        .where(organization_id: current_user.organization_id, status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today, Date.today + 30.days)
        .count
      
      # Get contracts for display (ordered by urgency)
      @alerts = Contract
        .where(organization_id: current_user.organization_id, status: 'active')
        .where('end_date > ? AND end_date <= ?', Date.today, Date.today + 90.days)
        .order(:end_date)
        .includes(:site)
    else
      @total_contracts = 0
      @attention_count = 0
      @alert_count = 0
      @alerts = []
    end
  end

  def show
    # Renders alerts/show.html.erb
  end

  def acknowledge
    # Handle alert acknowledgment
    redirect_to alerts_path
  end

  def settings
    # Renders alerts/settings.html.erb
  end

  def update_settings
    # Handle settings update
    redirect_to alerts_path
  end
end
