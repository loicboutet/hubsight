class RoutesController < ApplicationController
  def index
    # Routes organized by role based on specification.md
    @routes_by_role = {
      'Admin (5000.dev)' => [
        { name: 'Portfolio Managers', path: '/admin/portfolio_managers', description: 'Create and configure Portfolio Manager accounts' },
        { name: 'Client Data Access', path: '/admin/clients', description: 'Access client data (with authorization)' },
        { name: 'Price References', path: '/admin/price_references', description: 'Manage price reference database (BRIQUE 2)' },
        { name: 'Import Price References', path: '/admin/price_references/import', description: 'Import Excel price references' },
        { name: 'Export Price References', path: '/admin/price_references/export', description: 'Export price references to Excel' }
      ],
      'Portfolio Manager (Gestionnaire de Portefeuille)' => [
        { name: 'Dashboard', path: '/dashboard', description: 'Main dashboard with portfolio overview' },
        { name: 'Analytics', path: '/analytics', description: 'View analytics and key indicators' },
        { name: 'Sites', path: '/sites', description: 'Manage sites in portfolio (includes Buildings, Levels, Spaces)' },
        { name: 'Equipment', path: '/equipment', description: 'Manage equipment with OmniClass classification' },
        { name: 'Contracts', path: '/contracts', description: 'Manage contracts with PDF upload and OCR extraction' },
        { name: 'Upload Contracts', path: '/contracts/upload', description: 'Upload PDF contracts for automatic extraction' },
        { name: 'Organizations', path: '/organizations', description: 'Manage organizations and service providers (includes contacts)' },
        { name: 'Site Managers', path: '/site_managers', description: 'Create and manage Site Manager profiles' },
        { name: 'Alerts', path: '/alerts', description: 'View and manage contract alerts (BRIQUE 2)' },
        { name: 'Alert Settings', path: '/alerts/settings', description: 'Configure alert notifications' },
        { name: 'Savings Analysis', path: '/savings', description: 'View potential savings and price comparisons (BRIQUE 2)' },
        { name: 'Savings Report', path: '/savings/report', description: 'Generate economic analysis report (BRIQUE 2)' },
        { name: 'Equipment Types', path: '/equipment_types', description: 'Browse OmniClass equipment classification' },
        { name: 'Contract Families', path: '/contract_families', description: 'Browse contract families and sub-families' },
        { name: 'Search', path: '/search', description: 'Global search across all resources' },
        { name: 'Export Contracts', path: '/exports/contracts', description: 'Export contract data' },
        { name: 'Export Equipment', path: '/exports/equipment', description: 'Export equipment data' },
        { name: 'Export Sites', path: '/exports/sites', description: 'Export site data' }
      ],
      'Site Manager (Responsable de Site)' => [
        { name: 'My Sites', path: '/my_sites', description: 'View assigned sites' },
        { name: 'My Contracts', path: '/my_contracts', description: 'View contracts for assigned sites' },
        { name: 'Upload Contracts', path: '/my_contracts/upload', description: 'Upload contracts for assigned sites' },
        { name: 'My Alerts', path: '/my_alerts', description: 'View alerts for assigned sites (BRIQUE 2)' },
        { name: 'My Savings', path: '/my_savings', description: 'View potential savings for assigned sites (BRIQUE 2)' }
      ],
      'Technician (Technicien)' => [
        { name: 'Buildings', path: '/buildings', description: 'View buildings (read-only access)' },
        { name: 'Equipment', path: '/equipment', description: 'Manage equipment and maintenance' },
        { name: 'Contracts', path: '/contracts', description: 'View contracts (read-only access)' }
      ]
    }
  end
end
