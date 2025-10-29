class RoutesController < ApplicationController
  def index
    # Routes organized by role based on specification.md
    @routes_by_role = {
      'Admin (5000.dev)' => [
        # Dashboard Section
        { name: 'Tableau de bord', path: '/dashboard?role=admin', description: 'Main admin dashboard with overview' },
        { name: 'Analytiques', path: '/analytics?role=admin', description: 'Analytics overview (BRIQUE 2)' },
        
        # Admin Management Section
        { name: 'Gestionnaires de Portefeuille', path: '/admin/portfolio_managers', description: 'Manage portfolio manager users' },
        { name: 'Clients', path: '/admin/clients', description: 'View and access client portfolios' },
        { name: 'Responsables de Site', path: '/site_managers?role=admin', description: 'Manage site manager users and site assignments' },
        { name: 'Références de Prix', path: '/admin/price_references', description: 'Manage reference pricing data (BRIQUE 2)' },
        
        # Portfolio Section
        { name: 'Sites', path: '/sites?role=admin', description: 'List and manage all sites' },
        { name: 'Équipements', path: '/equipment?role=admin', description: 'List and manage all equipment' },
        { name: 'Contrats', path: '/contracts?role=admin', description: 'List and manage all contracts' },
        
        # Resources Section
        { name: 'Organisations', path: '/organizations?role=admin', description: 'Manage organizations (contractors, suppliers)' },
        { name: 'Types d\'Équipement', path: '/equipment_types?role=admin', description: 'View equipment type catalog (OmniClass)' },
        { name: 'Familles de Contrats', path: '/contract_families?role=admin', description: 'View contract families & subfamilies' },
        
        # Monitoring Section (BRIQUE 2)
        { name: 'Alertes', path: '/alerts?role=admin', description: 'Dashboard of all alerts across all portfolios' },
       
        # Tools Section
        { name: 'Recherche Globale', path: '/search?role=admin', description: 'Universal search across all entities' }
      ],
      'Portfolio Manager (Gestionnaire de Portefeuille)' => [
        { name: 'Tableau de bord', path: '/dashboard', description: 'Portfolio manager dashboard' },
        { name: 'Analytiques', path: '/analytics', description: 'Analytics overview (BRIQUE 2)' },
        { name: 'Sites', path: '/sites', description: 'List all sites in portfolio' },
        { name: 'Équipements', path: '/equipment', description: 'List all equipment (with filters)' },
        { name: 'Contrats', path: '/contracts', description: 'List all contracts (with filters)' },
        { name: 'Organisations', path: '/organizations', description: 'List organizations' },
        { name: 'Responsables de Site', path: '/site_managers', description: 'List all site managers' },
        { name: 'Alertes', path: '/alerts', description: 'Dashboard of all alerts' },
        { name: 'Paramètres d\'Alertes', path: '/alerts/settings', description: 'Alert settings form' },
        { name: 'Types d\'Équipement', path: '/equipment_types', description: 'List equipment type catalog (OmniClass)' },
        { name: 'Familles de Contrats', path: '/contract_families', description: 'List contract families & subfamilies' },
        { name: 'Recherche', path: '/search', description: 'Global search across all entities' }
      ],
      'Site Manager (Responsable de Site)' => [
        { name: 'Tableau de bord', path: '/dashboard', description: 'Site manager dashboard (assigned sites)' },
        { name: 'Mes Sites', path: '/my_sites', description: 'List assigned sites' },
        { name: 'Mes Contrats', path: '/my_contracts', description: 'List contracts for assigned sites' },
        { name: 'Mes Alertes', path: '/my_alerts', description: 'View alerts for assigned sites (BRIQUE 2)' },
        { name: 'Mes Économies', path: '/my_savings', description: 'View potential savings for assigned sites (BRIQUE 2)' }
      ],
      'Technician (Technicien)' => [
        { name: 'Bâtiments', path: '/technician/buildings', description: 'View buildings (read-only access)' },
        { name: 'Équipements', path: '/technician/equipment', description: 'Manage equipment and maintenance' },
        { name: 'Contrats', path: '/technician/contracts', description: 'View contracts (read-only access)' }
      ]
    }
  end
end
