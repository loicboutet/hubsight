class EquipmentType < ApplicationRecord
  # Associations
  has_many :equipment, dependent: :nullify
  
  # Validations
  validates :code, presence: true, uniqueness: true
  validates :equipment_type_name, presence: true
  validates :technical_lot_trigram, presence: true
  validates :technical_lot, presence: true
  validates :status, presence: true, inclusion: { in: %w[active inactive] }
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :by_technical_lot, ->(lot) { where(technical_lot_trigram: lot) if lot.present? }
  scope :by_subfamily, ->(subfamily) { where(purchase_subfamily: subfamily) if subfamily.present? }
  scope :by_function, ->(function) { where(function: function) if function.present? }
  scope :search, ->(query) {
    where("equipment_type_name LIKE ? OR code LIKE ? OR omniclass_number LIKE ? OR function LIKE ?", 
          "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%", 
          "%#{sanitize_sql_like(query)}%", "%#{sanitize_sql_like(query)}%") if query.present?
  }
  scope :ordered, -> { order(:technical_lot_trigram, :equipment_type_name) }
  
  # Constants - Technical Lots (from documentation)
  TECHNICAL_LOTS = {
    'CEA' => 'Corps d\'État Architecturaux',
    'CVC' => 'Chauffage, Ventilation, Climatisation',
    'ELE' => 'Électricité',
    'PLO' => 'Plomberie',
    'SEC' => 'Sécurité et Systèmes d\'Urgence',
    'ASC' => 'Ascenseurs et Élévateurs',
    'CTE' => 'Contrôle Technique',
    'AUT' => 'Automatisation et GTB',
    'DIV' => 'Divers'
  }.freeze
  
  # Purchase Subfamilies (from documentation)
  PURCHASE_SUBFAMILIES = [
    'MENUISERIE EXTÉRIEURE',
    'ASCENSEURS ET AUTOMATISATION',
    'CVC',
    'ÉLECTRICITÉ',
    'PLOMBERIE',
    'SYSTÈMES D\'URGENCE',
    'SÉCURITÉ INCENDIE',
    'CONTRÔLE D\'ACCÈS',
    'NETTOYAGE',
    'TOITURE',
    'FAÇADES',
    'REVÊTEMENTS',
    'ÉCLAIRAGE',
    'CHAUFFAGE',
    'CLIMATISATION',
    'VENTILATION',
    'EAU FROIDE',
    'EAU CHAUDE',
    'ASSAINISSEMENT',
    'SPRINKLERS'
  ].freeze
  
  # Helper methods
  def technical_lot_name
    TECHNICAL_LOTS[technical_lot_trigram] || technical_lot
  end
  
  def display_name
    "#{code} - #{equipment_type_name}"
  end
  
  def full_classification
    parts = []
    parts << technical_lot_name if technical_lot_trigram.present?
    parts << purchase_subfamily if purchase_subfamily.present?
    parts << function if function.present?
    parts.join(' > ')
  end
  
  def active?
    status == 'active'
  end
  
  # Color badge for technical lot (for UI display)
  def lot_badge_color
    case technical_lot_trigram
    when 'CVC' then 'blue'
    when 'ELE' then 'yellow'
    when 'PLO' then 'cyan'
    when 'SEC' then 'red'
    when 'ASC' then 'purple'
    when 'CEA' then 'green'
    when 'CTE' then 'orange'
    when 'AUT' then 'indigo'
    else 'gray'
    end
  end
  
  # Get all characteristics as an array
  def characteristics
    (1..10).map { |i| send("characteristic_#{i}") }.compact
  end
end
