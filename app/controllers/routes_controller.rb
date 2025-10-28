class RoutesController < ApplicationController
  def index
    # Routes organized by role based on specification.md
    @routes_by_role = {
      'Admin (5000.dev)' => [
        # Dashboard Section
        { name: 'Dashboard', path: '/dashboard?role=admin', description: 'Main admin dashboard with overview' },
        { name: 'Analytics', path: '/analytics?role=admin', description: 'Analytics overview (BRIQUE 2)' },
        
        # Admin Management Section
        { name: 'Portfolio Managers', path: '/admin/portfolio_managers', description: 'Manage portfolio manager users' },
        { name: 'Clients', path: '/admin/clients', description: 'View and access client portfolios' },
        { name: 'Site Managers', path: '/site_managers?role=admin', description: 'Manage site manager users and site assignments' },
        { name: 'Price References', path: '/admin/price_references', description: 'Manage reference pricing data (BRIQUE 2)' },
        
        # Portfolio Section
        { name: 'Sites', path: '/sites?role=admin', description: 'List and manage all sites' },
        { name: 'Equipment', path: '/equipment?role=admin', description: 'List and manage all equipment' },
        { name: 'Contracts', path: '/contracts?role=admin', description: 'List and manage all contracts' },
        
        # Resources Section
        { name: 'Organizations', path: '/organizations?role=admin', description: 'Manage organizations (contractors, suppliers)' },
        { name: 'Equipment Types', path: '/equipment_types?role=admin', description: 'View equipment type catalog (OmniClass)' },
        { name: 'Contract Families', path: '/contract_families?role=admin', description: 'View contract families & subfamilies' },
        
        # Monitoring Section (BRIQUE 2)
        { name: 'Alerts', path: '/alerts?role=admin', description: 'Dashboard of all alerts across all portfolios' },
        { name: 'Savings Analysis', path: '/savings?role=admin', description: 'View potential savings overview' },
        
        # Tools Section
        { name: 'Global Search', path: '/search?role=admin', description: 'Universal search across all entities' }
      ],
      'Portfolio Manager (Gestionnaire de Portefeuille)' => [
        { name: 'Dashboard', path: '/dashboard', description: 'Portfolio manager dashboard' },
        { name: 'Analytics', path: '/analytics', description: 'Analytics overview (BRIQUE 2)' },
        { name: 'Sites', path: '/sites', description: 'List all sites in portfolio' },
        { name: 'Equipment', path: '/equipment', description: 'List all equipment (with filters)' },
        { name: 'Contracts', path: '/contracts', description: 'List all contracts (with filters)' },
        { name: 'Organizations', path: '/organizations', description: 'List organizations' },
        { name: 'Site Managers', path: '/site_managers', description: 'List all site managers' },
        { name: 'Alerts', path: '/alerts', description: 'Dashboard of all alerts' },
        { name: 'Alert Settings', path: '/alerts/settings', description: 'Alert settings form' },
        { name: 'Equipment Types', path: '/equipment_types', description: 'List equipment type catalog (OmniClass)' },
        { name: 'Contract Families', path: '/contract_families', description: 'List contract families & subfamilies' },
        { name: 'Search', path: '/search', description: 'Global search across all entities' }
      ],
      'Site Manager (Responsable de Site)' => [
        { name: 'Dashboard', path: '/my_sites', description: 'Site manager dashboard (assigned sites)' },
        { name: 'My Sites', path: '/my_sites', description: 'List assigned sites' },
        { name: 'My Contracts', path: '/my_contracts', description: 'List contracts for assigned sites' },
        { name: 'Contract Upload', path: '/my_contracts/upload', description: 'Upload contract for assigned site' },
        { name: 'My Alerts', path: '/my_alerts', description: 'View alerts for assigned sites (BRIQUE 2)' },
        { name: 'My Savings', path: '/my_savings', description: 'View potential savings for assigned sites (BRIQUE 2)' }
      ],
      'Technician (Technicien)' => [
        { name: 'Buildings', path: '/technician/buildings', description: 'View buildings (read-only access)' },
        { name: 'Equipment', path: '/technician/equipment', description: 'Manage equipment and maintenance' },
        { name: 'Contracts', path: '/technician/contracts', description: 'View contracts (read-only access)' }
      ]
    }
  end
end
