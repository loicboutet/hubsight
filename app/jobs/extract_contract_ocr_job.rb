# Background job for extracting text from contract PDFs using OCR
# Processes PDFs asynchronously to avoid blocking the upload process
class ExtractContractOcrJob < ApplicationJob
  queue_as :default
  
  # Retry configuration with exponential backoff
  retry_on StandardError, wait: :exponentially_longer, attempts: 3
  
  # Perform OCR text extraction for a contract
  # @param contract_id [Integer] ID of the contract to process
  def perform(contract_id)
    contract = Contract.find(contract_id)
    
    # Check if contract has a PDF attached
    unless contract.pdf_attached?
      contract.update(
        ocr_status: 'failed',
        ocr_error_message: 'No PDF document attached to contract'
      )
      return
    end
    
    # Mark as processing
    contract.update(ocr_status: 'processing')
    
    # Extract text using OCR service
    result = OcrService.extract_text(contract.pdf_document)
    
    if result[:success]
      # OCR successful - save extracted text
      contract.update(
        ocr_status: 'completed',
        ocr_text: result[:text],
        ocr_page_count: result[:page_count],
        ocr_provider: result[:provider],
        ocr_processed_at: Time.current,
        ocr_error_message: nil
      )
      
      Rails.logger.info("Contract ##{contract.id}: OCR completed using #{result[:provider]} - #{result[:page_count]} pages, #{result[:text]&.length || 0} characters extracted")
      
      # Queue LLM extraction job
      Rails.logger.info("Contract ##{contract.id}: Queuing LLM extraction job")
      ExtractContractDataJob.perform_later(contract.id)
    else
      # OCR failed - save error message
      contract.update(
        ocr_status: 'failed',
        ocr_error_message: result[:error],
        ocr_provider: result[:provider]
      )
      
      Rails.logger.error("OCR failed for Contract ##{contract.id}: #{result[:error]}")
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Contract ##{contract_id} not found: #{e.message}")
  rescue => e
    # Handle any other errors
    Rails.logger.error("OCR job failed for Contract ##{contract_id}: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    
    # Update contract with error status
    contract = Contract.find_by(id: contract_id)
    if contract
      contract.update(
        ocr_status: 'failed',
        ocr_error_message: "Unexpected error: #{e.message}"
      )
    end
    
    # Re-raise to trigger retry mechanism
    raise e
  end
end
