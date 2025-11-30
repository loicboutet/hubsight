Rails.application.routes.draw do
  # =============================================================================
  # AUTHENTICATION & COMMON ROUTES
  # =============================================================================
  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    password: 'password',
    confirmation: 'confirmation'
  }
  
  # Invitations
  get 'invitations/accept/:token', to: 'invitations#show', as: :accept_invitation
  put 'invitations/accept/:token', to: 'invitations#update'
  
  # Role-based dashboard redirect
  get 'dashboard', to: 'dashboard#index', as: :dashboard

  # =============================================================================
  # ADMIN NAMESPACE
  # =============================================================================
  
  namespace :admin do
    # Portfolio Managers Management
    resources :portfolio_managers do
      member do
        post :resend_invitation
      end
    end
    
    # Organizations Management
    resources :organizations do
      member do
        post :toggle_status
      end
    end
    
    # Client Data Access
    resources :clients, only: [:index] do
      member do
        post :impersonate
      end
    end
    post 'stop_impersonation', to: 'clients#stop_impersonation'
    
    # Admin Access Logs (Audit trail for client data access)
    resources :access_logs, only: [:index, :show]
    
    # Price Reference Management (BRIQUE 2)
    resources :price_references do
      collection do
        get :import
        post :import, action: :process_import
        get :export
      end
    end
  end

  # =============================================================================
  # PORTFOLIO MANAGER ROUTES (Main Application)
  # =============================================================================
  
  # Dashboard & Analytics
  get 'analytics', to: 'analytics#index'
  
  # Portfolio Tree View (Hierarchical Navigation)
  get 'portfolio', to: 'portfolio#index', as: :portfolio
  
  # Sites Management with nested resources
  resources :sites do
    # Buildings nested under sites
    resources :buildings, only: [:index, :new, :create]
  end
  
  # Buildings Management
  resources :buildings, except: [:index, :new, :create] do
    # Levels nested under buildings
    resources :levels, only: [:index, :new, :create, :show]
  end
  
  # Levels Management
  resources :levels, only: [:show, :edit, :update, :destroy] do
    # Spaces nested under levels
    resources :spaces, only: [:index, :new, :create]
  end
  
  # Spaces Management
  resources :spaces, except: [:index, :new, :create] do
    # Equipment nested under spaces
    resources :equipment, only: [:new, :create]
  end
  
  # Equipment Management
  resources :equipment do
    collection do
      get :search
    end
  end
  
  # Contract Management
  resources :contracts do
    collection do
      get 'upload'
      post 'process_upload'
      get 'compare'
    end
    member do
      get 'validate'
      post 'confirm_validation'
      get 'pdf'
      delete 'delete_pdf'
    end
  end
  
  # Organizations Management
  resources :organizations do
    # Contacts nested under organizations
    resources :contacts, only: [:index, :new, :create]
    collection do
      get :search
    end
  end
  
  # Contacts Management (standalone index + nested actions)
  resources :contacts do
    collection do
      get :search
    end
  end
  
  # Site Managers Management
  resources :site_managers do
    member do
      get :assign_sites
      patch :assign_sites, action: :update_site_assignments
      post :resend_invitation
    end
  end
  
  # Alerts Management (BRIQUE 2)
  resources :alerts do
    member do
      patch :acknowledge
    end
    collection do
      get :settings
      patch :settings, action: :update_settings
    end
  end
  
  # Economic Analysis (BRIQUE 2)
  get 'savings', to: 'savings#index'
  get 'savings/report', to: 'savings#report'
  post 'savings/export_selection', to: 'savings#export_selection', as: :export_selection_savings
  
  # Audit Trail (BRIQUE 2)
  get 'audit_trail', to: 'audit_trail#index'
  
  # User Management
  resources :users
  
  # Profile Management
  get 'profile/edit', to: 'users#edit_profile', as: :edit_profile
  patch 'profile', to: 'users#update_profile', as: :update_profile
  
  # Active Session Management (renamed to avoid conflict with Devise)
  get 'active_sessions', to: 'sessions#index', as: :sessions
  delete 'active_sessions/:id', to: 'sessions#destroy', as: :session
  
  # Settings
  resources :settings, only: [:index, :update]
  
  # Referrals
  resources :referrals, only: [:index, :create]

  # =============================================================================
  # SITE MANAGER ROUTES (Scoped to assigned sites)
  # =============================================================================
  
  # Dashboard
  get 'my_sites', to: 'site_manager/sites#index'
  get 'my_sites/:id', to: 'site_manager/sites#show', as: :my_site
  get 'my_sites/:id/equipment', to: 'site_manager/sites#equipment', as: :my_site_equipment
  
  # Contracts (Limited access)
  get 'my_contracts', to: 'site_manager/contracts#index'
  get 'my_contracts/:id', to: 'site_manager/contracts#show', as: :my_contract
  get 'my_contracts/:id/pdf', to: 'site_manager/contracts#pdf', as: :my_contract_pdf
  get 'my_contracts/upload', to: 'site_manager/contracts#upload'
  post 'my_contracts/upload', to: 'site_manager/contracts#process_upload'
  
  # Alerts (Read-only, BRIQUE 2)
  get 'my_alerts', to: 'site_manager/alerts#index'
  
  # Savings (Read-only, BRIQUE 2)
  get 'my_savings', to: 'site_manager/savings#index'

  # =============================================================================
  # TECHNICIAN ROUTES (Read-only access to buildings, full access to equipment)
  # =============================================================================
  
  namespace :technician do
    # Buildings (Read-only)
    resources :buildings, only: [:index, :show]
    
    # Equipment (Full CRUD)
    resources :equipment do
      collection do
        get :search
      end
    end
    
    # Contracts (Read-only)
    resources :contracts, only: [:index, :show] do
      member do
        get :pdf
      end
    end
  end

  # =============================================================================
  # SHARED RESOURCES & UTILITIES
  # =============================================================================
  
  # Reference Data (Read-only)
  resources :equipment_types, only: [:index] do
    collection do
      get :search
    end
  end
  
  resources :contract_families, only: [:index] do
    collection do
      get :search
    end
  end
  
  # Imports (Portfolio Manager & Admin)
  namespace :imports do
    post :equipment_types
    post :spaces
    post :contract_families
  end
  
  # Exports (Based on permissions)
  namespace :exports do
    get :contracts
    get :equipment
    get :sites
  end

  # =============================================================================
  # SEARCH & FILTERING
  # =============================================================================
  
  # Global and resource-specific search
  get 'search', to: 'search#index'
  get 'search/contracts', to: 'search#contracts'
  get 'search/equipment', to: 'search#equipment'
  get 'search/sites', to: 'search#sites'
  get 'search/organizations', to: 'search#organizations'

  # =============================================================================
  # API ENDPOINTS (for AJAX/SPA features)
  # =============================================================================
  
  namespace :api do
    # Hierarchy and relationships
    get 'sites/:id/hierarchy', to: 'sites#hierarchy'
    get 'contracts/:id/linked_equipment', to: 'contracts#linked_equipment'
    get 'equipment/:id/contracts', to: 'equipment#contracts'
    
    # Equipment Types autocomplete/search
    get 'equipment_types/autocomplete', to: 'equipment_types#autocomplete'
    
    # Autocomplete endpoints
    namespace :autocomplete do
      get :equipment_types
      get :organizations
      get :contacts
    end
    
    # Alerts count
    get 'alerts/count', to: 'alerts#count'
  end

  # =============================================================================
  # HEALTH & SYSTEM ROUTES
  # =============================================================================
  
  # Health check for load balancers
  get "up" => "rails/health#show", as: :rails_health_check
  
  # PWA manifest and service worker (optional)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # =============================================================================
  # MOCKUPS (Development/Testing only - remove in production)
  # =============================================================================
  
  # Mockups routes
  get 'mockups/index'
  get 'mockups/user_dashboard'
  get 'mockups/user_profile'
  get 'mockups/user_settings'
  get 'mockups/admin_dashboard'
  get 'mockups/admin_users'
  get 'mockups/admin_analytics'
  get 'mockups/typography'

  # =============================================================================
  # ROUTES INDEX (Public - shows all routes organized by role)
  # =============================================================================
  
  get 'routes', to: 'routes#index', as: :routes_index

  # =============================================================================
  # ROOT ROUTE
  # =============================================================================
  
  # Show routes index to all users
  root to: 'routes#index'
end
