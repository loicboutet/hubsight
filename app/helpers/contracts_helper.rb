module ContractsHelper
  # Helper method to determine field style based on whether it has a value
  # Returns CSS styling for visual feedback during validation
  def field_style(value)
    if value.present?
      "background-color: #f0fdf4; border: 2px solid #10b981;" # Green for populated fields
    else
      "background-color: #fef2f2; border: 2px solid #ef4444;" # Red for empty fields
    end
  end
  
  # Normalize values for comparison to handle different data types and formats
  # Especially important for dates which may be stored as Date objects vs strings
  def normalize_value_for_comparison(value, field_type)
    return nil if value.blank?
    
    case field_type
    when :date
      # Convert dates to ISO string format for consistent comparison
      normalize_date_value(value)
    when :boolean
      # Normalize booleans
      normalize_boolean_value(value)
    when :integer
      value.to_i
    when :decimal, :float
      value.to_f.round(2) # Round to 2 decimals for comparison
    else
      # For strings, strip whitespace and convert to string
      value.to_s.strip
    end
  rescue => e
    Rails.logger.error("Error normalizing value for comparison: #{e.message}")
    value.to_s # Fallback to string comparison
  end
  
  private
  
  # Normalize date values to ISO format string (YYYY-MM-DD)
  def normalize_date_value(value)
    return nil if value.blank?
    
    # If it's already a Date or Time object, convert to ISO format
    if value.is_a?(Date) || value.is_a?(Time) || value.is_a?(DateTime)
      return value.to_date.iso8601
    end
    
    # If it's a string, try to parse it
    if value.is_a?(String)
      # If already in ISO format, return as is
      return value if value.match?(/^\d{4}-\d{2}-\d{2}$/)
      
      # Try to parse various formats
      begin
        Date.parse(value).iso8601
      rescue ArgumentError
        value # Return original if parsing fails
      end
    else
      value.to_s
    end
  end
  
  # Normalize boolean values
  def normalize_boolean_value(value)
    return true if value == true || value.to_s.downcase.in?(['true', '1', 'yes', 'oui', 't', 'y'])
    return false if value == false || value.to_s.downcase.in?(['false', '0', 'no', 'non', 'f', 'n'])
    nil
  end
end
