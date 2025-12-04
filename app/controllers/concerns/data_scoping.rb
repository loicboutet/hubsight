# app/controllers/concerns/data_scoping.rb
# Concern for handling role-based data scoping across controllers
module DataScoping
  extend ActiveSupport::Concern

  # Get contracts scoped by current user's role and permissions
  def scoped_contracts
    if current_user.admin?
      # Admins see all contracts across all organizations
      Contract.all
    elsif current_user.portfolio_manager?
      # Portfolio managers see all contracts for their organization
      Contract.by_organization(current_user.organization_id)
    elsif current_user.site_manager?
      # Site managers see only contracts for their assigned sites
      assigned_site_ids = current_user.assigned_sites.pluck(:id)
      Contract.where(site_id: assigned_site_ids, organization_id: current_user.organization_id)
    elsif current_user.technician?
      # Technicians see contracts for their assigned sites
      assigned_site_ids = current_user.assigned_sites.pluck(:id)
      Contract.where(site_id: assigned_site_ids, organization_id: current_user.organization_id)
    else
      # Default: no access
      Contract.none
    end
  end

  # Get sites scoped by current user's role and permissions
  def scoped_sites
    if current_user.admin?
      # Admins see all sites across all organizations
      Site.all
    elsif current_user.portfolio_manager?
      # Portfolio managers see all sites for their organization
      Site.where(organization_id: current_user.organization_id)
    elsif current_user.site_manager? || current_user.technician?
      # Site managers and technicians see only their assigned sites
      current_user.assigned_sites
    else
      # Default: no access
      Site.none
    end
  end

  # Get buildings scoped by current user's role and permissions
  def scoped_buildings
    if current_user.admin?
      Building.all
    elsif current_user.portfolio_manager?
      Building.where(organization_id: current_user.organization_id)
    elsif current_user.site_manager? || current_user.technician?
      assigned_site_ids = current_user.assigned_sites.pluck(:id)
      Building.where(site_id: assigned_site_ids)
    else
      Building.none
    end
  end

  # Get equipment scoped by current user's role and permissions
  def scoped_equipment
    if current_user.admin?
      Equipment.all
    elsif current_user.portfolio_manager?
      Equipment.where(organization_id: current_user.organization_id)
    elsif current_user.site_manager? || current_user.technician?
      assigned_site_ids = current_user.assigned_sites.pluck(:id)
      Equipment.where(site_id: assigned_site_ids)
    else
      Equipment.none
    end
  end

  # Get users scoped by current user's role and permissions
  def scoped_users
    if current_user.admin?
      User.all
    elsif current_user.portfolio_manager?
      User.where(organization_id: current_user.organization_id)
    elsif current_user.site_manager?
      # Site managers can see users in their organization
      User.where(organization_id: current_user.organization_id)
    elsif current_user.technician?
      # Technicians see users in their organization
      User.where(organization_id: current_user.organization_id)
    else
      User.none
    end
  end

  # Get organizations scoped by current user's role and permissions
  def scoped_organizations
    if current_user.admin?
      Organization.all
    else
      # Non-admins only see their own organization
      Organization.where(id: current_user.organization_id)
    end
  end
end
