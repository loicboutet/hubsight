# Base LLM Provider - Abstract class for LLM extraction providers
# Similar architecture to OCR service providers
module Llm
  class BaseProvider
    # Extract structured contract data from OCR text
    # @param ocr_text [String] Raw text from OCR
    # @return [Hash] Result with extracted data
    def extract_from_text(ocr_text)
      raise NotImplementedError, "#{self.class} must implement extract_from_text"
    end
    
    protected
    
    # Standard success result format
    def success_result(extracted_data, confidence:, model: nil, notes: nil)
      {
        success: true,
        extracted_data: extracted_data,
        confidence: confidence,
        model: model,
        notes: notes
      }
    end
    
    # Standard error result format
    def error_result(message)
      {
        success: false,
        extracted_data: {},
        confidence: 0,
        model: nil,
        notes: message,
        error: message
      }
    end
    
    # Extract contract number from text using common patterns
    def extract_contract_number(text)
      # Common patterns: "Contrat N°123", "N° 456", "Numéro: 789", etc.
      patterns = [
        /contrat\s*n[°o]\s*[:\-]?\s*([A-Z0-9\-\/]+)/i,
        /n[°o]\s*[:\-]?\s*([A-Z0-9\-\/]+)/i,
        /num[ée]ro\s*[:\-]?\s*([A-Z0-9\-\/]+)/i,
        /r[ée]f[ée]rence\s*[:\-]?\s*([A-Z0-9\-\/]+)/i
      ]
      
      patterns.each do |pattern|
        match = text.match(pattern)
        return match[1].strip if match
      end
      
      nil
    end
    
    # Extract dates from text
    def extract_date(text, keywords: [])
      # Look for dates near keywords
      date_patterns = [
        /(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/,  # DD/MM/YYYY or DD-MM-YYYY
        /(\d{1,2})\s+(janvier|février|mars|avril|mai|juin|juillet|août|septembre|octobre|novembre|décembre)\s+(\d{4})/i
      ]
      
      keywords.each do |keyword|
        text.scan(/#{keyword}[:\s]+(.{0,50})/) do |context|
          date_patterns.each do |pattern|
            match = context[0].match(pattern)
            return parse_french_date(match) if match
          end
        end
      end
      
      nil
    end
    
    # Extract amounts from text
    def extract_amount(text, keywords: [])
      # Look for amounts like "10 000 €", "10.000,00 EUR", etc.
      amount_pattern = /(\d[\d\s.,]*)\s*€|EUR/i
      
      keywords.each do |keyword|
        text.scan(/#{keyword}[:\s]+(.{0,100})/) do |context|
          match = context[0].match(amount_pattern)
          return parse_amount(match[1]) if match
        end
      end
      
      nil
    end
    
    # Extract organization names
    def extract_organization(text, keywords: [])
      keywords.each do |keyword|
        # Look for capitalized names after keywords
        pattern = /#{keyword}[:\s]+([A-ZÉÈÊ][A-Za-zÀ-ÿ\s&\-]{2,50})/i
        match = text.match(pattern)
        return match[1].strip if match
      end
      
      nil
    end
    
    private
    
    def parse_french_date(match)
      # Simple date parsing - can be enhanced
      if match[2] # Month name format
        month_names = {
          'janvier' => 1, 'février' => 2, 'mars' => 3, 'avril' => 4,
          'mai' => 5, 'juin' => 6, 'juillet' => 7, 'août' => 8,
          'septembre' => 9, 'octobre' => 10, 'novembre' => 11, 'décembre' => 12
        }
        day = match[1].to_i
        month = month_names[match[2].downcase]
        year = match[3].to_i
        Date.new(year, month, day).to_s rescue nil
      else # Numeric format DD/MM/YYYY
        day = match[1].to_i
        month = match[2].to_i
        year = match[3].to_i
        Date.new(year, month, day).to_s rescue nil
      end
    end
    
    def parse_amount(amount_str)
      # Remove spaces and convert French format to decimal
      return nil if amount_str.blank?
      
      # Replace French thousand separator (space) and decimal separator (,)
      cleaned = amount_str.gsub(/\s/, '').gsub(',', '.')
      cleaned.to_f
    end
  end
end
