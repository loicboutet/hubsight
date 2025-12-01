module Impersonation
  extend ActiveSupport::Concern

  included do
    before_action :check_impersonation_timeout
    helper_method :impersonating?, :impersonated_organization, :current_organization
  end

  # Check if admin is currently impersonating a client
  def impersonating?
    session[:impersonating_organization_id].present? && 
    session[:original_admin_id].present?
  end

  # Get the organization being impersonated
  def impersonated_organization
    return nil unless impersonating?
    @impersonated_organization ||= Organization.find_by(id: session[:impersonating_organization_id])
  end

  # Get current organization context (impersonated or user's own)
  def current_organization
    if impersonating?
      impersonated_organization
    elsif current_user&.organization_id
      current_user.organization
    else
      nil
    end
  end

  # Start impersonation session
  def start_impersonation(organization)
    return false unless current_user&.admin?
    return false if organization.nil?

    # Log the impersonation start
    access_log = AdminAccessLog.log_impersonation_start(
      current_user, 
      organization, 
      request
    )

    # Set session variables
    session[:impersonating_organization_id] = organization.id
    session[:original_admin_id] = current_user.id
    session[:impersonation_started_at] = Time.current.to_i
    session[:impersonation_log_id] = access_log.id

    true
  end

  # Stop impersonation session
  def stop_impersonation
    return false unless impersonating?

    # End the access log
    if session[:impersonation_log_id]
      log = AdminAccessLog.find_by(id: session[:impersonation_log_id])
      log&.end_impersonation!
    end

    # Clear session variables
    session.delete(:impersonating_organization_id)
    session.delete(:original_admin_id)
    session.delete(:impersonation_started_at)
    session.delete(:impersonation_log_id)

    true
  end

  # Check if impersonation has timed out (optional security feature)
  def check_impersonation_timeout
    return unless impersonating?
    
    # Default timeout: 2 hours
    timeout_duration = 2.hours.to_i
    started_at = session[:impersonation_started_at]
    
    if started_at && (Time.current.to_i - started_at) > timeout_duration
      stop_impersonation
      redirect_to admin_clients_path, alert: 'Session d\'accès client expirée pour des raisons de sécurité.'
    end
  end

  # Ensure only admins can impersonate
  def require_admin_for_impersonation
    unless current_user&.admin?
      redirect_to root_path, alert: 'Accès non autorisé.'
    end
  end

  # Scope queries to current organization context
  def scoped_to_organization(relation)
    org = current_organization
    return relation unless org
    
    # If the relation's table has an organization_id column, scope it
    if relation.column_names.include?('organization_id')
      relation.where(organization_id: org.id)
    else
      relation
    end
  end
end
