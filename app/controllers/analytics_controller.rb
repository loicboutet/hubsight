class AnalyticsController < ApplicationController
  include DataScoping
  
  before_action :authenticate_user!

  def index
    #===========================================
    # USER ACTIVITY METRICS (KPI Cards)
    # ===========================================
    users = scoped_users
    @total_active_users = users.where(status: 'active').count
    @total_users = users.count
    
    @new_users_this_week = users.where('created_at >= ?', 7.days.ago).count
    
    # Get active sessions scoped to visible users
    user_ids = users.pluck(:id)
    @connections_this_week = ActiveSession.where(user_id: user_ids).where('created_at >= ?', 7.days.ago).count
    @connections_this_month = ActiveSession.where(user_id: user_ids).where('created_at >= ?', 30.days.ago).count
    
    # Calculate average session duration from active sessions
    sessions_with_duration = ActiveSession.where(user_id: user_ids)
                                          .where.not(updated_at: nil)
                                          .where('updated_at > created_at')
    
    if sessions_with_duration.any?
      # Database-agnostic duration calculation
      total_duration = sessions_with_duration.sum do |session|
        (session.updated_at - session.created_at).to_i
      end
      avg_duration_seconds = (total_duration / sessions_with_duration.count).to_i
      minutes = avg_duration_seconds / 60
      seconds = avg_duration_seconds % 60
      @avg_session_duration = "#{minutes}m #{seconds}s"
    else
      @avg_session_duration = "0m 0s"
    end
    
    # ===========================================
    # CONTRACT ENTRY ACTIVITY
    # ===========================================
    contracts = scoped_contracts
    
    @contracts_last_24h = contracts.where('created_at >= ?', 24.hours.ago).count
    @contracts_last_48h = contracts.where('created_at >= ?', 48.hours.ago).count
    @contracts_this_week = contracts.where('created_at >= ?', 7.days.ago).count
    @contracts_this_month = contracts.where('created_at >= ?', 30.days.ago).count
    
    # Weekly trend data for chart (last 7 weeks)
    @weekly_contract_trend = []
    6.downto(0) do |weeks_ago|
      week_start = weeks_ago.weeks.ago.beginning_of_week
      week_end = weeks_ago.weeks.ago.end_of_week
      week_count = contracts.where(created_at: week_start..week_end).count
      
      # Format week number (ISO week)
      week_num = week_start.strftime('%U')
      @weekly_contract_trend << { week: "Sem #{week_num}", count: week_count }
    end
    
    # Daily trend for current week
    @daily_contract_trend = []
    day_names = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam']
    
    0.upto(6) do |days_ago|
      day = (6 - days_ago).days.ago.to_date
      day_count = contracts.where('DATE(created_at) = ?', day).count
      day_name = day_names[day.wday]
      @daily_contract_trend << { day: day_name, count: day_count }
    end
    
    # ===========================================
    # ACTIVITY BY PORTFOLIO CLIENT (Organizations)
    # ===========================================
    organizations = scoped_organizations
    
    @client_activity = organizations.map do |org|
      org_contracts = if current_user.admin?
        Contract.where(organization_id: org.id)
      elsif current_user.portfolio_manager?
        Contract.where(organization_id: org.id)
      else
        # For site managers/technicians, only show contracts from their assigned sites
        assigned_site_ids = current_user.assigned_sites.pluck(:id)
        Contract.where(organization_id: org.id, site_id: assigned_site_ids)
      end
      
      org_users = User.where(organization_id: org.id)
      last_session = ActiveSession.joins(:user).where(users: { organization_id: org.id }).order(created_at: :desc).first
      
      {
        name: org.name,
        contracts_24h: org_contracts.where('created_at >= ?', 24.hours.ago).count,
        contracts_48h: org_contracts.where('created_at >= ?', 48.hours.ago).count,
        contracts_week: org_contracts.where('created_at >= ?', 7.days.ago).count,
        contracts_month: org_contracts.where('created_at >= ?', 30.days.ago).count,
        active_users: org_users.where(status: 'active').count,
        last_activity: last_session ? time_ago_in_words_fr(last_session.created_at) : 'N/A'
      }
    end.sort_by { |a| -a[:contracts_month] }.first(10) # Top 10 most active
    
    # ===========================================
    # ACTIVITY BY SITE
    # ===========================================
    sites = scoped_sites.includes(:organization)
    
    @site_activity = sites.map do |site|
      site_contracts = contracts.where(site_id: site.id)
      
      # Last activity for this site
      last_contract = site_contracts.order(created_at: :desc).first
      
      {
        name: site.name,
        contracts_24h: site_contracts.where('created_at >= ?', 24.hours.ago).count,
        contracts_48h: site_contracts.where('created_at >= ?', 48.hours.ago).count,
        contracts_week: site_contracts.where('created_at >= ?', 7.days.ago).count,
        contracts_month: site_contracts.where('created_at >= ?', 30.days.ago).count,
        most_active_user: 'N/A', # Creator tracking not implemented yet
        last_activity: last_contract ? time_ago_in_words_fr(last_contract.created_at) : 'N/A'
      }
    end.sort_by { |s| -s[:contracts_month] }.first(10) # Top 10 most active sites
    
    # ===========================================
    # PERSONALIZED ALERTS WITH DEADLINES
    # ===========================================
    # Get contracts approaching renewal/deadline
    today = Date.today
    upcoming_contracts = contracts.where('end_date IS NOT NULL AND end_date >= ? AND end_date <= ?', today, today + 90.days)
                                  .order(:end_date)
    
    @personalized_alerts = upcoming_contracts.map do |contract|
      days_remaining = (contract.end_date - today).to_i
      
      # Determine priority based on days remaining
      priority = if days_remaining <= 7
        'high'
      elsif days_remaining <= 30
        'medium'
      else
        'low'
      end
      
      # Determine alert type
      alert_type = if contract.renewal_count.to_i > 0
        'Renouvellement Contrat'
      else
        'Fin de Contrat'
      end
      
      {
        type: alert_type,
        description: "#{contract.contract_number} - #{contract.title}",
        deadline: contract.end_date,
        days_remaining: days_remaining,
        priority: priority,
        site: contract.site&.name || 'Tous sites'
      }
    end.first(20) # Limit to 20 most urgent
    
    # ===========================================
    # USAGE PATTERNS & TRENDS
    # ===========================================
    # Peak hours analysis - based on active sessions
    sessions = ActiveSession.where(user_id: user_ids).where('created_at >= ?', 30.days.ago)
    
    hour_ranges = [
      { range: '8h-10h', start: 8, end: 10 },
      { range: '10h-12h', start: 10, end: 12 },
      { range: '14h-16h', start: 14, end: 16 },
      { range: '16h-18h', start: 16, end: 18 }
    ]
    
    total_sessions = sessions.count.to_f
    total_sessions = 1 if total_sessions == 0 # Avoid division by zero
    
    @peak_usage_hours = hour_ranges.map do |hr|
      # Database-agnostic hour extraction
      count = sessions.select { |s| s.created_at.hour >= hr[:start] && s.created_at.hour < hr[:end] }.count
      {
        hour: hr[:range],
        percentage: ((count / total_sessions) * 100).round
      }
    end
    
    # Most active users - based on session activity
    # Note: Contract creator tracking not implemented yet
    @most_active_users = users.map do |user|
      sessions_count = ActiveSession.where(user_id: user.id).where('created_at >= ?', 30.days.ago).count
      
      {
        name: user.full_name,
        role: user.role.titleize,
        actions: sessions_count
      }
    end.sort_by { |u| -u[:actions] }.first(5)
    
    # Feature usage statistics - track page/controller access
    # Note: This would require additional tracking in the future
    # For now, we'll use contract-related activities as a proxy
    equipment_count = scoped_equipment.where('created_at >= ?', 30.days.ago).count
    sites_with_activity = sites.where('updated_at >= ?', 30.days.ago).count
    
    total_activities = @contracts_this_month + equipment_count + sites_with_activity + @connections_this_month
    total_activities = 1 if total_activities == 0
    
    @feature_usage = [
      { feature: 'Contrats', views: @contracts_this_month, percentage: ((@contracts_this_month.to_f / total_activities) * 100).round },
      { feature: 'Équipements', views: equipment_count, percentage: ((equipment_count.to_f / total_activities) * 100).round },
      { feature: 'Sites', views: sites_with_activity, percentage: ((sites_with_activity.to_f / total_activities) * 100).round },
      { feature: 'Connexions', views: @connections_this_month, percentage: ((@connections_this_month.to_f / total_activities) * 100).round }
    ].sort_by { |f| -f[:views] }
    
    # ===========================================
    # CONTRACT DISTRIBUTION ANALYSIS
    # ===========================================
    contracts_by_family = contracts.group(:contract_family).count
    total_contracts = contracts_by_family.values.sum.to_f
    total_contracts = 1 if total_contracts == 0 # Avoid division by zero
    
    colors = ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b', '#fa709a']
    @contract_by_family = contracts_by_family.map.with_index do |(family, count), index|
      {
        family: family || 'Non classé',
        count: count,
        percentage: ((count / total_contracts) * 100).round,
        color: colors[index % colors.length]
      }
    end
    
    # Contract distribution by status
    status_map = {
      'active' => { label: 'Actif', color: '#10b981' },
      'expired' => { label: 'Expiré', color: '#ef4444' },
      'pending' => { label: 'En renouvellement', color: '#f59e0b' },
      'suspended' => { label: 'Suspendu', color: '#6b7280' }
    }
    
    contracts_by_status = contracts.group(:status).count
    @contract_by_status = contracts_by_status.map do |status, count|
      status_info = status_map[status] || { label: status, color: '#6b7280' }
      {
        status: status_info[:label],
        count: count,
        percentage: ((count / total_contracts) * 100).round,
        color: status_info[:color]
      }
    end
    
    # ===========================================
    # SPENDING TRENDS ANALYSIS
    # ===========================================
    # Monthly spending trends for current year
    month_names = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc']
    current_year = Date.today.year
    
    @monthly_spending = month_names.map.with_index do |month_name, index|
      month_num = index + 1
      month_start = Date.new(current_year, month_num, 1)
      month_end = month_start.end_of_month
      
      # Get contracts active during this month
      month_contracts = contracts.where('(start_date <= ? AND (end_date >= ? OR end_date IS NULL))', month_end, month_start)
      actual_amount = month_contracts.sum(:annual_amount) / 12.0 # Convert annual to monthly
      
      # For budget, assume 10% buffer over actual
      budget_amount = actual_amount * 1.1
      
      {
        month: month_name,
        amount: actual_amount.round,
        budget: budget_amount.round
      }
    end
    
    # Spending by contract family
    spending_by_family = contracts.group(:contract_family).sum(:annual_amount)
    
    total_spending = spending_by_family.values.sum.to_f
    total_spending = 1 if total_spending == 0
    
    colors_spending = ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b', '#fa709a']
    @spending_by_family = spending_by_family.map.with_index do |(family, amount), index|
      {
        family: family || 'Non classé',
        amount: amount.to_i,
        percentage: ((amount / total_spending) * 100).round,
        color: colors_spending[index % colors_spending.length]
      }
    end
    
    # Total spending metrics
    @total_annual_spending = contracts.sum(:annual_amount).to_i
    @budget_total = (@total_annual_spending * 1.1).round # 10% budget buffer
    @budget_used_percentage = @budget_total > 0 ? ((@total_annual_spending.to_f / @budget_total) * 100).round(1) : 0
    
    # ===========================================
    # EQUIPMENT DISTRIBUTION ANALYSIS
    # ===========================================
    equipment = scoped_equipment
    
    # Equipment distribution by type
    equipment_by_type = equipment.joins(:equipment_type)
                                 .group('equipment_types.equipment_type_name')
                                 .count
    total_equipment = equipment_by_type.values.sum.to_f
    total_equipment = 1 if total_equipment == 0
    
    colors_equipment = ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#fa709a', '#43e97b', '#feca57', '#95a5a6']
    @equipment_by_type = equipment_by_type.map.with_index do |(type, count), index|
      {
        type: type || 'Non classé',
        count: count,
        percentage: ((count / total_equipment) * 100).round,
        color: colors_equipment[index % colors_equipment.length]
      }
    end
    
    # Equipment distribution by site (top 10)
    equipment_by_site = equipment.joins(:site)
                                 .group('sites.name')
                                 .count
                                 .sort_by { |k, v| -v }
                                 .first(10)
    
    @equipment_by_site = equipment_by_site.map do |site_name, count|
      { site: site_name, count: count }
    end
    
    # Equipment age distribution
    all_equipment = equipment.where.not(commissioning_date: nil)
    age_counts = { '0-5 ans' => 0, '6-10 ans' => 0, '11-15 ans' => 0, '16-20 ans' => 0, '20+ ans' => 0 }
    
    all_equipment.each do |eq|
      age_range = eq.age_range
      age_counts[age_range] += 1 if age_range
    end
    
    total_with_age = age_counts.values.sum.to_f
    total_with_age = 1 if total_with_age == 0
    
    age_colors = {
      '0-5 ans' => '#10b981',
      '6-10 ans' => '#3b82f6',
      '11-15 ans' => '#f59e0b',
      '16-20 ans' => '#ef4444',
      '20+ ans' => '#991b1b'
    }
    
    @equipment_age_distribution = age_counts.map do |age_range, count|
      {
        age_range: age_range,
        count: count,
        percentage: ((count / total_with_age) * 100).round,
        color: age_colors[age_range]
      }
    end
    
    @total_equipment_count = equipment.count
  end
  
  private
  
  # Helper method to convert time to French relative time
  def time_ago_in_words_fr(time)
    seconds = (Time.current - time).to_i
    
    case seconds
    when 0..59
      'À l\'instant'
    when 60..3599
      minutes = seconds / 60
      "#{minutes} minute#{minutes > 1 ? 's' : ''}"
    when 3600..86399
      hours = seconds / 3600
      "#{hours} heure#{hours > 1 ? 's' : ''}"
    when 86400..604799
      days = seconds / 86400
      "#{days} jour#{days > 1 ? 's' : ''}"
    when 604800..2591999
      weeks = seconds / 604800
      "#{weeks} semaine#{weeks > 1 ? 's' : ''}"
    else
      months = seconds / 2592000
      "#{months} mois"
    end
  end
end
