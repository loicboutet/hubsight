class ContractFamily < ApplicationRecord
  # Validations
  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :family_type, presence: true, inclusion: { in: %w[family subfamily] }
  validates :status, inclusion: { in: %w[active inactive] }
  validates :parent_code, presence: true, if: :subfamily?

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :ordered, -> { order(:display_order, :code) }
  scope :families_only, -> { where(family_type: 'family') }
  scope :subfamilies_only, -> { where(family_type: 'subfamily') }
  scope :by_family, ->(parent_code) { where(parent_code: parent_code) }
  scope :search, ->(query) { where('code LIKE ? OR name LIKE ?', "%#{query}%", "%#{query}%") }

  # Instance Methods
  
  # Returns formatted display name
  def display_name
    "#{code} - #{name}"
  end

  # Check if this is a top-level family
  def family?
    family_type == 'family'
  end
  alias_method :is_family?, :family?

  # Check if this is a subfamily
  def subfamily?
    family_type == 'subfamily'
  end
  alias_method :is_subfamily?, :subfamily?

  # Returns parent family object (for subfamilies)
  def parent_family
    return nil if family?
    self.class.find_by(code: parent_code)
  end

  # Returns all subfamilies (for families)
  def subfamilies
    return [] if subfamily?
    self.class.where(parent_code: code).ordered
  end

  # Returns all children (alias for subfamilies)
  def children
    subfamilies
  end

  # Returns the full hierarchy path
  def hierarchy_path
    if family?
      name
    else
      parent = parent_family
      parent ? "#{parent.name} > #{name}" : name
    end
  end

  # Returns badge color for UI based on family type
  def family_badge_color
    case code
    when /^MAIN/
      'blue'
    when /^NETT/
      'green'
    when /^CTRL/
      'yellow'
    when /^FLUI/
      'purple'
    when /^ASSU/
      'red'
    when /^IMMO/
      'indigo'
    when /^AUTR/
      'gray'
    else
      'slate'
    end
  end

  # Class Methods
  
  # Returns all top-level families
  def self.families
    families_only.ordered
  end

  # Returns subfamilies for a given parent code
  def self.subfamilies_of(parent_code)
    by_family(parent_code).ordered
  end

  # Returns count of families
  def self.families_count
    families_only.count
  end

  # Returns count of subfamilies
  def self.subfamilies_count
    subfamilies_only.count
  end

  # Group all by family
  def self.grouped_by_family
    result = {}
    families.each do |family|
      result[family] = family.subfamilies
    end
    result
  end
end
