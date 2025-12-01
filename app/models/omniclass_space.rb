class OmniclassSpace < ApplicationRecord
  # Validations
  validates :code, presence: true, uniqueness: true
  validates :title, presence: true
  validates :status, inclusion: { in: %w[active inactive] }
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :inactive, -> { where(status: 'inactive') }
  scope :ordered, -> { order(:code) }
  scope :by_category, ->(category_prefix) { where("code LIKE ?", "#{category_prefix}%") }
  scope :search, ->(query) {
    where("code LIKE ? OR title LIKE ?", "%#{query}%", "%#{query}%") if query.present?
  }
  
  # Helper method to get the display name (code + title)
  def display_name
    "#{code} - #{title}"
  end
  
  # Helper method to determine the hierarchy level based on code structure
  # OmniClass codes follow pattern: XX-XX XX XX (level 1), XX-XX XX XX XX (level 2), etc.
  def category_level
    # Count the number of non-zero segments in the code
    segments = code.split(/[\s-]/).reject { |s| s == '00' }
    segments.length
  end
  
  # Helper method to get the parent category code (if exists)
  def parent_code
    # Extract parent by replacing last non-zero segment with 00
    parts = code.split(/[\s-]/)
    return nil if parts.all? { |p| p == '00' }
    
    # Find the last non-zero part and replace with 00
    parts.reverse.each_with_index do |part, idx|
      if part != '00'
        parts[-(idx + 1)] = '00'
        break
      end
    end
    parts.join(' ')
  end
  
  # Helper method to get major category (first two digits)
  def major_category
    code[0..1]
  end
  
  # Helper method for UI badge colors based on major category
  def category_badge_color
    case major_category
    when '13'
      case code[3..4]
      when '11' then 'green'    # Outdoor Spaces
      when '21' then 'blue'     # Building Spaces
      when '31' then 'red'      # Healthcare Spaces
      when '41' then 'yellow'   # Residential Spaces
      when '51' then 'purple'   # Commercial Spaces
      when '61' then 'gray'     # Industrial Spaces
      when '71' then 'orange'   # Transportation Spaces
      else 'indigo'
      end
    else 'gray'
    end
  end
  
  # Class method to get all major categories
  def self.major_categories
    active.where("code LIKE '%00 00 00'")
          .where.not("code LIKE '%00 00 00 00%'")
          .ordered
  end
  
  # Class method to get subcategories for a given parent code
  def self.subcategories_of(parent_code)
    # Find codes that start with the parent pattern but are more specific
    prefix = parent_code.gsub(/\s*00\s*$/, '')
    where("code LIKE ?", "#{prefix}%")
      .where.not(code: parent_code)
      .ordered
  end
end
