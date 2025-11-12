class AnalyticsController < ApplicationController
  def index
    # NOTE: This is mock data for prototype. Replace with real database queries when models are implemented.
    
    # ===========================================
    # USER ACTIVITY METRICS (KPI Cards)
    # ===========================================
    # TODO: Replace with User.where(last_sign_in_at: 30.days.ago..Time.now).count
    @total_active_users = 47
    @total_users = 52
    
    # TODO: Replace with User.where(created_at: 7.days.ago..Time.now).count
    @new_users_this_week = 3
    
    # TODO: Replace with connection/session tracking
    @connections_this_week = 156
    @connections_this_month = 634
    
    # TODO: Calculate average from session data
    @avg_session_duration = "12m 34s"
    
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
  end
end
