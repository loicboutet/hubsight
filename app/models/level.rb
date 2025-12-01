class Level < ApplicationRecord
  # Associations
  belongs_to :building
  belongs_to :organization
  has_many :spaces, dependent: :destroy
  has_many :equipment, through: :spaces

  # Validations
  validates :name, presence: true
  validates :building_id, presence: true
  validates :organization_id, presence: true
  validates :level_number, numericality: { only_integer: true }, allow_nil: true
  validates :altitude, numericality: true, allow_nil: true
  validates :area, numericality: { greater_than: 0 }, allow_nil: true

  # Ensure level belongs to same organization as building
  validate :building_belongs_to_organization

  # Scopes
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_building, ->(building_id) { where(building_id: building_id) }
  scope :ordered, -> { order(:level_number) }

  # Virtual attributes for counts
  def spaces_count
    spaces.count
  end

  def equipment_count
    # To be implemented when Equipment model is properly set up
    0
  end

  # Formatted area display
  def formatted_area
    return nil unless area
    "#{area.to_i} m²"
  end

  # Formatted altitude display
  def formatted_altitude
    return nil unless altitude
    "#{altitude} m"
  end

  private

  def building_belongs_to_organization
    if building && organization_id && building.organization_id != organization_id
      errors.add(:building, "must belong to the same organization")
    end
  end
end
