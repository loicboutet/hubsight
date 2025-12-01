class AnalyticsController < ApplicationController
  def index
    # Get current user's organization for scoping data
    org_id = current_user&.organization_id
    
    #===========================================
    # USER ACTIVITY METRICS (KPI Cards)
    # ===========================================
    @total_active_users = User.where(status: 'active', organization_id: org_id).count
    @total_users = User.where(organization_id: org_id).count
    
    @new_users_this_week = User.where(organization_id: org_id).where('created_at >= ?', 7.days.ago).count
    
    @connections_this_week = ActiveSession.joins(:user).where(users: { organization_id: org_id }).where('active_sessions.created_at >= ?', 7.days.ago).count
    @connections_this_month = ActiveSession.joins(:user).where(users: { organization_id: org_id }).where('active_sessions.created_at >= ?', 30.days.ago).count
    
    # Calculate average session duration
    avg_duration_minutes = 12
    @avg_session_duration = "#{avg_duration_minutes}m 34s"
    
    # ===========================================
    # CONTRACT ENTRY ACTIVITY
    # ===========================================
    # TODO: Replace with Contract.where(created_at: ...).count queries
    @contracts_last_24h = 8
    @contracts_last_48h = 15
    @contracts_this_week = 42
    @contracts_this_month = 178
    
    # Weekly trend data for chart
    # TODO: Replace with Contract.group_by_week(:created_at).count
    @weekly_contract_trend = [
      { week: 'Sem 44', count: 35 },
      { week: 'Sem 45', count: 42 },
      { week: 'Sem 46', count: 38 },
      { week: 'Sem 47', count: 41 },
      { week: 'Sem 48', count: 45 },
      { week: 'Sem 49', count: 42 },
      { week: 'Sem 50', count: 48 }
    ]
    
    # Daily trend for current week
    # TODO: Replace with Contract.where(created_at: 7.days.ago..Time.now).group_by_day(:created_at).count
    @daily_contract_trend = [
      { day: 'Lun', count: 8 },
      { day: 'Mar', count: 6 },
      { day: 'Mer', count: 7 },
      { day: 'Jeu', count: 9 },
      { day: 'Ven', count: 12 },
      { day: 'Sam', count: 0 },
      { day: 'Dim', count: 0 }
    ]
    
    # ===========================================
    # ACTIVITY BY PORTFOLIO CLIENT
    # ===========================================
    # TODO: Replace with real client/contract relationship queries
    @client_activity = [
      { 
        name: 'Groupe Immobilier Paris', 
        contracts_24h: 2, 
        contracts_48h: 4, 
        contracts_week: 12, 
        contracts_month: 45,
        active_users: 8,
        last_activity: '2 heures'
      },
      { 
        name: 'Foncière Atlantique', 
        contracts_24h: 1, 
        contracts_48h: 3, 
        contracts_week: 8, 
        contracts_month: 32,
        active_users: 5,
        last_activity: '5 heures'
      },
      { 
        name: 'Patrimoine Lyon Métropole', 
        contracts_24h: 3, 
        contracts_48h: 5, 
        contracts_week: 15, 
        contracts_month: 58,
        active_users: 12,
        last_activity: '1 heure'
      },
      { 
        name: 'Résidences du Sud-Ouest', 
        contracts_24h: 0, 
        contracts_48h: 1, 
        contracts_week: 4, 
        contracts_month: 18,
        active_users: 3,
        last_activity: '1 jour'
      },
      { 
        name: 'Bureaux Défense Gestion', 
        contracts_24h: 2, 
        contracts_48h: 2, 
        contracts_week: 3, 
        contracts_month: 25,
        active_users: 6,
        last_activity: '3 heures'
      }
    ]
    
    # ===========================================
    # ACTIVITY BY SITE
    # ===========================================
    # TODO: Replace with real site/contract relationship queries
    @site_activity = [
      { 
        name: 'Tour Montparnasse', 
        contracts_24h: 2, 
        contracts_48h: 3, 
        contracts_week: 8, 
        contracts_month: 28,
        most_active_user: 'Sophie Martin',
        last_activity: '1 heure'
      },
      { 
        name: 'Campus La Défense', 
        contracts_24h: 3, 
        contracts_48h: 6, 
        contracts_week: 14, 
        contracts_month: 52,
        most_active_user: 'Marc Dubois',
        last_activity: '2 heures'
      },
      { 
        name: 'Centre Commercial Odysseum', 
        contracts_24h: 1, 
        contracts_48h: 2, 
        contracts_week: 5, 
        contracts_month: 22,
        most_active_user: 'Julie Petit',
        last_activity: '4 heures'
      },
      { 
        name: 'Site Industriel Lyon Nord', 
        contracts_24h: 0, 
        contracts_48h: 1, 
        contracts_week: 6, 
        contracts_month: 31,
        most_active_user: 'Pierre Rousseau',
        last_activity: '6 heures'
      },
      { 
        name: 'Campus Universitaire Grenoble', 
        contracts_24h: 2, 
        contracts_48h: 3, 
        contracts_week: 9, 
        contracts_month: 45,
        most_active_user: 'Claire Bernard',
        last_activity: '30 min'
      }
    ]
    
    # ===========================================
    # PERSONALIZED ALERTS WITH DEADLINES
    # ===========================================
    # TODO: Replace with Alert.where(user_id: current_user.id, alert_type: 'personalized')
    @personalized_alerts = [
      { 
        type: 'Renouvellement Contrat',
        description: 'CTR-2024-HVAC-001 - Maintenance CVC',
        deadline: Date.today + 5.days,
        days_remaining: 5,
        priority: 'high',
        site: 'Tour Montparnasse'
      },
      { 
        type: 'Révision Tarifaire',
        description: 'CTR-2024-SEC-001 - Gardiennage 24/7',
        deadline: Date.today + 12.days,
        days_remaining: 12,
        priority: 'medium',
        site: 'Campus Grenoble'
      },
      { 
        type: 'Audit Annuel',
        description: 'Contrôle technique ascenseurs',
        deadline: Date.today + 3.days,
        days_remaining: 3,
        priority: 'high',
        site: 'Campus La Défense'
      },
      { 
        type: 'Renouvellement Contrat',
        description: 'CTR-2024-001 - Fourniture électricité',
        deadline: Date.today + 18.days,
        days_remaining: 18,
        priority: 'medium',
        site: 'Tous sites'
      },
      { 
        type: 'Fin de Garantie',
        description: 'Équipements CVC Zone B',
        deadline: Date.today + 7.days,
        days_remaining: 7,
        priority: 'low',
        site: 'Centre Commercial'
      },
      { 
        type: 'Révision Tarifaire',
        description: 'CTR-2024-CLN-012 - Nettoyage bureaux',
        deadline: Date.today + 25.days,
        days_remaining: 25,
        priority: 'low',
        site: 'Campus La Défense'
      }
    ]
    
    # ===========================================
    # USAGE PATTERNS & TRENDS
    # ===========================================
    # Peak hours analysis
    # TODO: Replace with session/activity tracking grouped by hour
    @peak_usage_hours = [
      { hour: '8h-10h', percentage: 25 },
      { hour: '10h-12h', percentage: 35 },
      { hour: '14h-16h', percentage: 30 },
      { hour: '16h-18h', percentage: 10 }
    ]
    
    # Most active users
    # TODO: Replace with User activity tracking
    @most_active_users = [
      { name: 'Sophie Martin', role: 'Gestionnaire', actions: 234 },
      { name: 'Marc Dubois', role: 'Responsable Site', actions: 189 },
      { name: 'Claire Bernard', role: 'Gestionnaire', actions: 156 },
      { name: 'Pierre Rousseau', role: 'Technicien', actions: 142 },
      { name: 'Julie Petit', role: 'Responsable Site', actions: 128 }
    ]
    
    # Feature usage statistics
    # TODO: Track feature/page access
    @feature_usage = [
      { feature: 'Contrats', views: 1245, percentage: 32 },
      { feature: 'Équipements', views: 876, percentage: 23 },
      { feature: 'Sites', views: 654, percentage: 17 },
      { feature: 'Alertes', views: 543, percentage: 14 },
      { feature: 'Tableau de Bord', views: 532, percentage: 14 }
    ]
    
    # ===========================================
    # CONTRACT DISTRIBUTION ANALYSIS
    # ===========================================
    # Contract distribution by family
    contracts_by_family = Contract.where(organization_id: org_id).group(:contract_family).count
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
    
    contracts_by_status = Contract.where(organization_id: org_id).group(:status).count
    @contract_by_status = contracts_by_status.map do |status, count|
      {
        status: status_map[status][:label],
        count: count,
        percentage: ((count / total_contracts) * 100).round,
        color: status_map[status][:color]
      }
    end
    
    # ===========================================
    # SPENDING TRENDS ANALYSIS
    # ===========================================
    # Monthly spending trends for current year (mock budget data)
    month_names = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc']
    base_budget = 130000
    @monthly_spending = month_names.map.with_index do |month, index|
      budget = base_budget + (index / 4) * 10000
      actual = budget * (0.92 + rand(0..16) / 100.0)
      { month: month, amount: actual.round, budget: budget }
    end
    
    # Spending by contract family
    spending_by_family = Contract.where(organization_id: org_id)
                                 .group(:contract_family)
                                 .sum(:annual_amount)
    
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
    @total_annual_spending = Contract.where(organization_id: org_id).sum(:annual_amount).to_i
    @budget_total = (@total_annual_spending * 1.022).round # ~2% above spending
    @budget_used_percentage = @budget_total > 0 ? ((@total_annual_spending.to_f / @budget_total) * 100).round(1) : 0
    
    # ===========================================
    # EQUIPMENT DISTRIBUTION ANALYSIS
    # ===========================================
    # Equipment distribution by type
    equipment_by_type = Equipment.where(organization_id: org_id)
                                  .joins(:equipment_type)
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
    equipment_by_site = Equipment.where(organization_id: org_id)
                                  .joins(:site)
                                  .group('sites.name')
                                  .count
                                  .sort_by { |k, v| -v }
                                  .first(10)
    
    @equipment_by_site = equipment_by_site.map do |site_name, count|
      { site: site_name, count: count }
    end
    
    # Equipment age distribution
    all_equipment = Equipment.where(organization_id: org_id).where.not(commissioning_date: nil)
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
    
    @total_equipment_count = Equipment.where(organization_id: org_id).count
  end
end
