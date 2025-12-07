# LLM Service - Contract data extraction from OCR text
# Supports multiple LLM providers with seamless switching
# Zero-cost MVP uses mock provider, can switch to paid OpenRouter when ready
class LlmService
  class << self
    # Extract structured contract data from OCR text
    # @param ocr_text [String] Raw text from OCR extraction
    # @param provider [Symbol] Provider to use (:auto, :mock, :openrouter)
    # @return [Hash] Result with :success, :extracted_data, :confidence, :provider, :model, :notes
    def extract_contract_data(ocr_text, provider: :auto)
      return error_result('No OCR text provided') if ocr_text.blank?
      
      provider_name = provider == :auto ? determine_provider : provider
      
      # Enhanced debugging logs
      Rails.logger.info("LLM Service: Selected provider: #{provider_name} (OpenRouter API key configured: #{openrouter_configured?})")
      Rails.logger.info("LLM Service: Rails.env = #{Rails.env}")
      Rails.logger.info("LLM Service: ENV['OPENROUTER_API_KEY'] = #{ENV['OPENROUTER_API_KEY'].present? ? 'present' : 'nil'}")
      Rails.logger.info("LLM Service: Rails.application.credentials.dig(:openrouter, :api_key) = #{Rails.application.credentials.dig(:openrouter, :api_key).present? ? 'present' : 'nil'}")
      
      provider_instance = get_provider(provider_name)
      
      result = provider_instance.extract_from_text(ocr_text)
      result.merge(provider: provider_name.to_s)
    rescue => e
      error_result("LLM extraction failed: #{e.message}")
    end
    
    # Check if a paid LLM provider is configured and ready
    def paid_provider_available?
      openrouter_configured?
    end
    
    # Get the current provider being used
    def current_provider_name
      determine_provider.to_s.titleize
    end
    
    private
    
    # Determine which provider to use based on configuration
    def determine_provider
      # Check if OpenRouter API key is configured
      if openrouter_configured?
        :openrouter
      else
        # Default to free mock provider for MVP
        :mock
      end
    end
    
    # Check if OpenRouter LLM is configured with valid API key
    # Checks both ENV vars (for local dev) and Rails credentials (for production)
    def openrouter_configured?
      openrouter_api_key.present?
    end
    
    # Get OpenRouter API key from ENV or credentials
    def openrouter_api_key
      ENV['OPENROUTER_API_KEY'] || Rails.application.credentials.dig(:openrouter, :api_key)
    end
    
    # Get OpenRouter model from ENV or credentials
    def openrouter_model
      ENV['OPENROUTER_MODEL'] || Rails.application.credentials.dig(:openrouter, :model) || 'anthropic/claude-3.5-sonnet'
    end
    
    # Get the appropriate provider instance
    def get_provider(provider_name)
      case provider_name
      when :mock
        Llm::MockProvider.new
      when :openrouter
        Llm::OpenrouterProvider.new
      else
        raise ArgumentError, "Unknown LLM provider: #{provider_name}"
      end
    end
    
    # Standard error result format
    def error_result(message)
      {
        success: false,
        extracted_data: {},
        confidence: 0,
        provider: 'error',
        model: nil,
        notes: message,
        error: message
      }
    end
  end
end
