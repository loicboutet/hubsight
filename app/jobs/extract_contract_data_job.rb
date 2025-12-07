# Background job to extract structured contract data from OCR text using LLM
# Automatically triggered after OCR completion
class ExtractContractDataJob < ApplicationJob
  queue_as :default
  
  def perform(contract_id)
    contract = Contract.find(contract_id)
    
    Rails.logger.info("Contract ##{contract_id}: LLM extraction job started")
    
    # Check if OCR is completed
    unless contract.ocr_completed?
      Rails.logger.warn("Contract ##{contract_id}: OCR not completed, skipping LLM extraction")
      return
    end
    
    # Skip if already extracted
    if contract.extraction_status == 'completed'
      Rails.logger.info("Contract ##{contract_id}: Already extracted, skipping")
      return
    end
    
    # Update status to processing
    contract.update(extraction_status: 'processing')
    Rails.logger.info("Contract ##{contract_id}: Extraction status set to 'processing'")
    
    # Call LLM service
    Rails.logger.info("Contract ##{contract_id}: Calling LLM service for data extraction (OCR text length: #{contract.ocr_text&.length || 0} chars)")
    result = LlmService.extract_contract_data(contract.ocr_text)
    
    if result[:success]
      # Update contract with extracted data
      update_contract_with_extracted_data(contract, result)
      
      Rails.logger.info("Contract #{contract_id}: Successfully extracted data using #{result[:provider]}")
    else
      # Mark as failed
      contract.update(
        extraction_status: 'failed',
        extraction_notes: result[:error] || result[:notes]
      )
      
      Rails.logger.error("Contract #{contract_id}: Extraction failed - #{result[:error]}")
    end
    
  rescue => e
    # Handle unexpected errors
    contract.update(
      extraction_status: 'failed',
      extraction_notes: "Erreur système: #{e.message}"
    )
    
    Rails.logger.error("Contract #{contract_id}: Extraction job error - #{e.message}")
    raise e
  end
  
  private
  
  def update_contract_with_extracted_data(contract, result)
    extracted_data = result[:extracted_data] || {}
    
    # IMPORTANT: Store extracted data in extraction_data JSON
    # Do NOT overwrite main contract fields yet - preserve original manual entries
    # Main fields will only be updated after user validation/approval
    contract.update(
      extraction_status: 'completed',
      extraction_data: extracted_data,
      extraction_provider: result[:provider],
      extraction_model: result[:model],
      extraction_confidence: result[:confidence],
      extraction_processed_at: Time.current,
      extraction_notes: result[:notes],
      validation_status: 'pending'  # Mark as pending validation
    )
  end
  
  def parse_date(date_value)
    return nil if date_value.blank?
    
    case date_value
    when Date, Time
      date_value
    when String
      Date.parse(date_value) rescue nil
    else
      nil
    end
  end
end
