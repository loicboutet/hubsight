module SiteManagerAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :ensure_site_manager_access, if: :site_manager_user?
  end

  private

  def site_manager_user?
    current_user&.site_manager?
  end

  def ensure_site_manager_access
    # Site managers can only access their assigned sites
    # This concern can be included in controllers that need site manager restrictions
  end

  # Check if the current site manager has access to a specific site
  def authorize_site_access!(site_id)
    return true unless current_user.site_manager?

    unless current_user.assigned_sites.exists?(site_id)
      redirect_to my_sites_path, alert: "Vous n'avez pas accès à ce site."
      return false
    end
    true
  end

  # Get sites accessible by the current user
  def accessible_sites
    if current_user.admin? || current_user.portfolio_manager?
      Site.where(organization_id: current_user.organization_id)
    elsif current_user.site_manager?
      current_user.assigned_sites
    else
      Site.none
    end
  end

  # Check if user has any assigned sites
  def has_assigned_sites?
    return true unless current_user.site_manager?
    current_user.assigned_sites.any?
  end
end
