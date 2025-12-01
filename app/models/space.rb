class Space < ApplicationRecord
  # Associations
  belongs_to :level
  belongs_to :organization
  has_many :equipment, dependent: :destroy

  # Validations
  validates :name, presence: true
  validates :level_id, presence: true
  validates :organization_id, presence: true
  validates :area, numericality: { greater_than: 0 }, allow_nil: true
  validates :ceiling_height, numericality: { greater_than: 0 }, allow_nil: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :water_points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :electrical_outlets, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :natural_lighting, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true

  # Ensure space belongs to same organization as level
  validate :level_belongs_to_organization

  # Scopes
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_level, ->(level_id) { where(level_id: level_id) }
  scope :by_type, ->(space_type) { where(space_type: space_type) }
  scope :ordered, -> { order(:name) }

  # OmniClass classification association (via string code match)
  def omniclass_classification
    return nil unless omniclass_code.present?
    @omniclass_classification ||= OmniclassSpace.find_by(code: omniclass_code)
  end
  
  # Helper to get OmniClass title
  def omniclass_title
    omniclass_classification&.title
  end
  
  # Helper to get formatted OmniClass display
  def omniclass_display
    return nil unless omniclass_code.present?
    classification = omniclass_classification
    classification ? classification.display_name : omniclass_code
  end

  # Virtual attributes for counts
  def equipment_count
    equipment.count
  end

  # Formatted area display
  def formatted_area
    return nil unless area
    "#{area.to_i} m²"
  end

  # Formatted ceiling height display
  def formatted_ceiling_height
    return nil unless ceiling_height
    "#{ceiling_height} m"
  end

  # Building relationship through level
  def building
    level&.building
  end

  # Site relationship through level and building
  def site
    building&.site
  end

  private

  def level_belongs_to_organization
    if level && organization_id && level.organization_id != organization_id
      errors.add(:level, "must belong to the same organization")
    end
  end
end
