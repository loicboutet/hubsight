class Site < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :buildings, dependent: :destroy
  
  # Validations
  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :site_type, presence: true, inclusion: { in: %w[bureaux industriel commercial residentiel logistique sante enseignement autre] }
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  validates :address, presence: true
  validates :city, presence: true
  validates :postal_code, presence: true, format: { with: /\A\d{5}\z/, message: "doit être composé de 5 chiffres" }
  validates :contact_email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :contact_phone, format: { with: /\A(\+33|0)[1-9](\d{2}){4}\z/, allow_blank: true, message: "format invalide" }
  validates :total_area, numericality: { greater_than: 0, allow_nil: true }
  validates :estimated_area, numericality: { greater_than: 0, allow_nil: true }
  
  # Scopes
  scope :active, -> { where(status: "active") }
  scope :inactive, -> { where(status: "inactive") }
  scope :by_type, ->(type) { where(site_type: type) if type.present? }
  scope :by_region, ->(region) { where(region: region) if region.present? }
  scope :search_by_name, ->(query) { where("name LIKE ?", "%#{sanitize_sql_like(query)}%") if query.present? }
  scope :search_by_city, ->(query) { where("city LIKE ?", "%#{sanitize_sql_like(query)}%") if query.present? }
  scope :ordered_by_name, -> { order(:name) }
  
  # Constants
  SITE_TYPES = {
    "bureaux" => "Bureaux",
    "industriel" => "Industriel",
    "commercial" => "Commercial",
    "residentiel" => "Résidentiel",
    "logistique" => "Logistique",
    "sante" => "Santé",
    "enseignement" => "Enseignement",
    "autre" => "Autre"
  }.freeze
  
  REGIONS = {
    "auvergne-rhone-alpes" => "Auvergne-Rhône-Alpes",
    "bourgogne-franche-comte" => "Bourgogne-Franche-Comté",
    "bretagne" => "Bretagne",
    "centre-val-de-loire" => "Centre-Val de Loire",
    "corse" => "Corse",
    "grand-est" => "Grand Est",
    "hauts-de-france" => "Hauts-de-France",
    "ile-de-france" => "Île-de-France",
    "normandie" => "Normandie",
    "nouvelle-aquitaine" => "Nouvelle-Aquitaine",
    "occitanie" => "Occitanie",
    "pays-de-la-loire" => "Pays de la Loire",
    "provence-alpes-cote-azur" => "Provence-Alpes-Côte d'Azur"
  }.freeze
  
  STATUSES = {
    "active" => "Actif",
    "inactive" => "Inactif"
  }.freeze
  
  # Callbacks
  before_save :normalize_fields
  before_create :set_created_by
  before_update :set_updated_by
  
  # Instance methods
  def site_type_label
    SITE_TYPES[site_type] || site_type&.capitalize
  end
  
  def region_label
    REGIONS[region] || region
  end
  
  def status_label
    STATUSES[status] || status&.capitalize
  end
  
  def full_address
    [address, postal_code, city, region].compact.join(", ")
  end
  
  def formatted_area
    return nil unless total_area
    "#{total_area.to_i.to_s.reverse.scan(/\d{1,3}/).join(' ').reverse} m²"
  end
  
  def buildings_count
    buildings.count
  end
  
  private
  
  def normalize_fields
    self.name = name&.strip
    self.city = city&.strip&.titleize
    self.postal_code = postal_code&.strip
    self.contact_email = contact_email&.strip&.downcase if contact_email.present?
  end
  
  def set_created_by
    self.created_by_name = user.full_name if user.present? && user.respond_to?(:full_name)
  end
  
  def set_updated_by
    self.updated_by_name = user.full_name if user.present? && user.respond_to?(:full_name)
  end
end
