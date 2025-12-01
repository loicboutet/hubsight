class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    # Get the current user's organization
    # Admin sees all data, other users see only their organization's data
    if current_user.admin?
      contracts = Contract.all
    else
      org_id = current_user.organization_id
      contracts = Contract.by_organization(org_id)
    end
    @contracts_by_status = contracts.group(:status).count
    @total_contracts = contracts.count
    
    # Contracts by Family
    @contracts_by_family = contracts.group(:contract_family)
      .select('contract_family, COUNT(*) as count, SUM(annual_amount) as total_amount')
      .where.not(contract_family: nil)
      .group(:contract_family)
      .order('SUM(annual_amount) DESC')
    
    # Total spending
    @total_spending = contracts.sum(:annual_amount) || 0
    
    # Calculate family percentages
    @family_distribution = @contracts_by_family.map do |family_data|
      {
        name: family_data.contract_family,
        contracts: family_data.count,
        amount: family_data.total_amount || 0,
        percentage: @total_spending > 0 ? ((family_data.total_amount || 0) / @total_spending * 100).round : 0
      }
    end
    
    # Upcoming Renewals (based on end_date)
    today = Date.today
    @renewals_30_days = contracts.where(end_date: today..today + 30.days).count
    @renewals_60_days = contracts.where(end_date: today + 31.days..today + 60.days).count
    @renewals_90_days = contracts.where(end_date: today + 61.days..today + 90.days).count
    
    # Get detailed renewal contracts for display
    @upcoming_renewals = contracts.where('end_date >= ? AND end_date <= ?', today, today + 90.days)
      .order(:end_date)
      .limit(10)
    
    # Sites count
    if current_user.admin?
      @sites_count = Site.count
      @buildings_count = Building.count
      @equipment_count = Equipment.count
    else
      org_id = current_user.organization_id
      @sites_count = Site.where(organization_id: org_id).count
      @buildings_count = Building.where(organization_id: org_id).count
      @equipment_count = Equipment.where(organization_id: org_id).count
    end
    
    # Service providers (unique contractor organizations)
    @providers_count = contracts.where.not(contractor_organization_name: nil)
      .distinct
      .count('contractor_organization_name')
    
    # Provider statistics
    if @providers_count > 0
      @avg_contracts_per_provider = (@total_contracts.to_f / @providers_count).round(1)
      
      # Find top provider by contract count
      top_provider_data = contracts.where.not(contractor_organization_name: nil)
        .group('contractor_organization_name')
        .select('contractor_organization_name, COUNT(*) as contract_count')
        .order('contract_count DESC')
        .first
      
      if top_provider_data
        @top_provider_name = top_provider_data.contractor_organization_name
        @top_provider_count = top_provider_data.contract_count
      end
    end
    
    # Recent contracts
    @recent_contracts = contracts.order(created_at: :desc).limit(5)
    
    # Top contracts by value
    @top_contracts = contracts.where.not(annual_amount: nil)
      .order(annual_amount: :desc)
      .limit(10)
  end
end
