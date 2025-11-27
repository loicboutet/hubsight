class Equipment < ApplicationRecord
  belongs_to :organization
  belongs_to :site, optional: true

  # Validations
  validates :organization_id, presence: true

  # Scopes
  scope :by_organization, ->(org_id) { where(organization_id: org_id) }
  scope :by_type, ->(type) { where(equipment_type: type) }
  scope :by_site, ->(site_id) { where(site_id: site_id) }
  
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
end
