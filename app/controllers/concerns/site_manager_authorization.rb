# frozen_string_literal: true

# Authorization concern for Site Manager-only actions
# Ensures only Site Managers can access certain resources
module SiteManagerAuthorization
  extend ActiveSupport::Concern

  included do
    before_action :require_site_manager!
  end

  private

  def require_site_manager!
    unless current_user&.site_manager?
      redirect_to root_path, alert: "Accès non autorisé. Cette fonctionnalité est réservée aux Responsables de Site."
    end
  end
  
  # Check if the current site manager has any assigned sites
  def has_assigned_sites?
    current_user.assigned_sites.any?
  end
end
