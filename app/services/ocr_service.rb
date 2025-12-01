# OCR Service - Multi-provider text extraction from PDF documents
# Supports multiple OCR providers with seamless switching
class OcrService
  class << self
    # Extract text from a PDF document using the configured provider
    # @param pdf_file [ActiveStorage::Blob] PDF file to extract text from
    # @param provider [Symbol] OCR provider to use (:auto, :pdf_reader, :mistral)
    # @return [Hash] Result hash with :success, :text, :page_count, :provider, :error
    def extract_text(pdf_file, provider: :auto)
      provider_name = provider == :auto ? determine_provider : provider
      provider_instance = get_provider(provider_name)
      
      result = provider_instance.extract(pdf_file)
      result.merge(provider: provider_name.to_s)
    rescue => e
      {
        success: false,
        text: nil,
        page_count: 0,
        provider: provider_name.to_s,
        error: "OCR extraction failed: #{e.message}"
      }
    end
    
    private
    
    # Determine which provider to use based on configuration and availability
    def determine_provider
      # Check if Mistral API key is configured
      if mistral_configured?
        :mistral
      else
        # Fall back to free pdf-reader for digital PDFs
        :pdf_reader
      end
    end
    
    # Check if Mistral OCR is configured with valid API key
    def mistral_configured?
      Rails.application.credentials.dig(:mistral, :api_key).present?
    end
    
    # Get the appropriate provider instance
    def get_provider(provider_name)
      case provider_name
      when :pdf_reader
        Ocr::PdfReaderProvider.new
      when :mistral
        Ocr::MistralProvider.new
      else
        raise ArgumentError, "Unknown OCR provider: #{provider_name}"
      end
    end
  end
end
