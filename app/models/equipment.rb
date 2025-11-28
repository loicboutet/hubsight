class Equipment < ApplicationRecord
  # Relationships
  belongs_to :organization
  belongs_to :space
  belongs_to :building, optional: true
  belongs_to :level, optional: true
  belongs_to :site, optional: true
  belongs_to :equipment_type, optional: true

  # Validations
  validates :organization_id, presence: true
  validates :space_id, presence: true
  validates :name, presence: true
  validates :manufacturer, presence: true
  validates :status, presence: true, inclusion: { in: %w[active inactive maintenance out_of_service decommissioned] }
  validates :criticality, inclusion: { in: %w[low medium high critical] }, allow_blank: true
  
  # Numeric validations
  validates :nominal_power, :nominal_voltage, :current, :frequency, :weight, :purchase_price,
            numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  # Scopes
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_type, ->(type) { where(equipment_type: type) }
  scope :by_site, ->(site_id) { where(site_id: site_id) }
  scope :by_space, ->(space_id) { where(space_id: space_id) }
  scope :by_building, ->(building_id) { where(building_id: building_id) }
  scope :by_level, ->(level_id) { where(level_id: level_id) }
  scope :by_status, ->(status) { where(status: status) }
  scope :active, -> { where(status: 'active') }
  scope :critical, -> { where(criticality: 'critical') }
  
  # Callbacks
  before_validation :set_hierarchy_from_space, if: :space_id_changed?
  
  # Calculate equipment age in years
  def age_in_years
    return nil unless commissioning_date
    ((Date.today - commissioning_date).to_i / 365.25).floor
  end
  
  # Age range for grouping
  def age_range
    age = age_in_years
    return nil unless age
    
    case age
    when 0..5
      '0-5 ans'
    when 6..10
      '6-10 ans'
    when 11..15
      '11-15 ans'
    when 16..20
      '16-20 ans'
    else
      '20+ ans'
    end
  end
  
  # Get full location path: Site > Building > Level > Space
  def location_path
    return nil unless space
    
    parts = []
    parts << space.level.building.site.name if space.level&.building&.site
    parts << space.level.building.name if space.level&.building
    parts << space.level.name if space.level
    parts << space.name
    parts.join(' > ')
  end
  
  # Status label in French
  def status_label
    {
      'active' => 'Actif',
      'inactive' => 'Inactif',
      'maintenance' => 'En maintenance',
      'out_of_service' => 'Hors service',
      'decommissioned' => 'Décommissionné'
    }[status] || status
  end
  
  # Criticality label in French
  def criticality_label
    {
      'low' => 'Faible',
      'medium' => 'Moyen',
      'high' => 'Élevé',
      'critical' => 'Critique'
    }[criticality] || criticality
  end
  
  private
  
  # Automatically set building, level, site from space
  def set_hierarchy_from_space
    return unless space
    
    self.level_id = space.level_id
    self.building_id = space.level&.building_id
    self.site_id = space.level&.building&.site_id
    self.organization_id = space.organization_id if organization_id.blank?
  end
end
