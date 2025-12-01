module DataIsolation
  extend ActiveSupport::Concern

  included do
    # Automatically scope queries to organization if the model has organization_id
    if column_names.include?('organization_id')
      scope :for_organization, ->(org_id) { where(organization_id: org_id) }
    end
  end

  class_methods do
    # Check if this model supports organization scoping
    def organization_scoped?
      column_names.include?('organization_id')
    end

    # Scope queries to current organization context
    # This should be called from controllers with current_organization
    def scoped_to_current_organization(organization)
      if organization_scoped? && organization
        for_organization(organization.id)
      else
        all
      end
    end
  end

  # Instance method to check if record belongs to organization
  def belongs_to_organization?(organization)
    return false unless organization
    return true unless self.class.organization_scoped?
    
    organization_id == organization.id
  end

  # Validate that the record belongs to the appropriate organization
  def validate_organization_access(current_organization)
    if self.class.organization_scoped? && current_organization
      unless belongs_to_organization?(current_organization)
        errors.add(:base, 'Accès non autorisé à cette ressource')
      end
    end
  end
end
