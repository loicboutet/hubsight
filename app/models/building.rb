class Building < ApplicationRecord
  # Associations
  belongs_to :site
  belongs_to :organization
  belongs_to :user  # Creator
  has_many :levels, dependent: :destroy
  has_many :spaces, through: :levels
  has_many :contracts

  # Validations
  validates :name, presence: true
  validates :site_id, presence: true
  validates :organization_id, presence: true
  validates :user_id, presence: true
  validates :status, inclusion: { in: %w[active inactive] }
  
  # Ensure building belongs to same organization as site
  validate :site_belongs_to_organization

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_site, ->(site_id) { where(site_id: site_id) }

  # Virtual attributes for counts (will be calculated from associations)
  def levels_count
    levels.count
  end

  def spaces_count
    spaces.count
  end

  def equipment_count
    # To be implemented when Equipment model is properly set up with space associations
    0
  end

  # Formatted area display
  def formatted_area
    return nil unless area
    "#{area.to_i} m²"
  end

  private

  def site_belongs_to_organization
    if site && organization_id && site.organization_id != organization_id
      errors.add(:site, "must belong to the same organization")
    end
  end
end
