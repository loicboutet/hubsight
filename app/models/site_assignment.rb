class SiteAssignment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :site

  # Validations
  validates :user_id, presence: true, uniqueness: { scope: :site_id }
  validates :site_id, presence: true
  validate :user_must_be_site_manager
  validate :site_belongs_to_user_organization

  # Callbacks
  before_create :set_assigned_at

  private

  def user_must_be_site_manager
    unless user&.site_manager?
      errors.add(:user, "must be a site manager")
    end
  end

  def site_belongs_to_user_organization
    if user && site && user.organization_id != site.organization_id
      errors.add(:site, "must belong to the same organization as the user")
    end
  end

  def set_assigned_at
    self.assigned_at ||= Time.current
  end
end
