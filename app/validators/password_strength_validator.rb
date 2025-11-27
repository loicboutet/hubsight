class PasswordStrengthValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    
    errors = []
    
    # Minimum length (already handled by Devise, but for clarity)
    errors << "doit contenir au moins 8 caractères" if value.length < 8
    
    # Must contain at least one uppercase letter
    errors << "doit contenir au moins une lettre majuscule" unless value.match?(/[A-Z]/)
    
    # Must contain at least one lowercase letter
    errors << "doit contenir au moins une lettre minuscule" unless value.match?(/[a-z]/)
    
    # Must contain at least one digit
    errors << "doit contenir au moins un chiffre" unless value.match?(/\d/)
    
    # Must contain at least one special character
    errors << "doit contenir au moins un caractère spécial (!@#$%^&*)" unless value.match?(/[!@#$%^&*(),.?":{}|<>]/)
    
    unless errors.empty?
      record.errors.add(attribute, "#{errors.join(', ')}")
    end
  end
end
