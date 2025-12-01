# OpenRouter LLM Provider - Production-ready paid extraction
# Requires openrouter.api_key in Rails credentials
# Supports 100+ LLM models (Claude, GPT-4, Llama, etc.)
# Cost: ~€0.02-0.04 per contract with Claude 3.5 Sonnet
module Llm
  class OpenrouterProvider < BaseProvider
    OPENROUTER_API_URL = 'https://openrouter.ai/api/v1/chat/completions'
    DEFAULT_MODEL = 'anthropic/claude-3.5-sonnet'
    MAX_TOKENS = 4000
    TEMPERATURE = 0.1
    
    def extract_from_text(ocr_text)
      return error_result('No OCR text provided') if ocr_text.blank?
      return error_result('OpenRouter API key not configured') unless api_key.present?
      
      response = call_openrouter_api(ocr_text)
      
      if response[:success]
        parse_llm_response(response[:content], response[:model])
      else
        error_result(response[:error])
      end
    rescue => e
      error_result("OpenRouter API error: #{e.message}")
    end
    
    private
    
    def api_key
      Rails.application.credentials.dig(:openrouter, :api_key)
    end
    
    def model_name
      Rails.application.credentials.dig(:openrouter, :model) || DEFAULT_MODEL
    end
    
    def call_openrouter_api(ocr_text)
      require 'net/http'
      require 'json'
      
      uri = URI.parse(OPENROUTER_API_URL)
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request['Authorization'] = "Bearer #{api_key}"
      request['HTTP-Referer'] = 'https://hubsight.app'
      request['X-Title'] = 'HubSight Contract Extraction'
      
      request.body = JSON.dump({
        model: model_name,
        messages: [
          { role: 'system', content: system_prompt },
          { role: 'user', content: "Extrayez les données:\n\n#{ocr_text.slice(0, 15000)}" }
        ],
        temperature: TEMPERATURE,
        max_tokens: MAX_TOKENS
      })
      
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(request)
      end
      
      if response.code == '200'
        data = JSON.parse(response.body)
        {
          success: true,
          content: data.dig('choices', 0, 'message', 'content'),
          model: data['model']
        }
      else
        { success: false, error: "API error #{response.code}" }
      end
    end
    
    def system_prompt
      <<~PROMPT
        Extrayez les données du contrat French au format JSON strict.
        Retournez uniquement le JSON, pas de texte supplémentaire.
        
        Format attendu:
        {
          "contract_number": "string",
          "title": "string",
          "contract_type": "string",
          "contractor_organization_name": "string",
          "annual_amount_ht": number,
          "signature_date": "YYYY-MM-DD",
          "execution_start_date": "YYYY-MM-DD",
          "initial_duration_months": number,
          "service_nature": "string"
        }
        
        Si un champ n'est pas trouvé, utilisez null.
      PROMPT
    end
    
    def parse_llm_response(content, model)
      # Extract JSON from response
      json_match = content.match(/\{.*\}/m)
      return error_result('No JSON in response') unless json_match
      
      extracted_data = JSON.parse(json_match[0], symbolize_names: true)
      
      success_result(
        extracted_data,
        confidence: 85.0,
        model: model,
        notes: "✅ Extraction LLM réelle via #{model}"
      )
    rescue JSON::ParserError => e
      error_result("JSON parsing error: #{e.message}")
    end
  end
end
