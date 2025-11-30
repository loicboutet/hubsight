# Background job to extract structured contract data from OCR text using LLM
# Automatically triggered after OCR completion
class ExtractContractDataJob < ApplicationJob
  queue_as :default
  
  def perform(contract_id)
    contract = Contract.find(contract_id)
    
    # Check if OCR is completed
    unless contract.ocr_completed?
      Rails.logger.warn("Contract #{contract_id}: OCR not completed, skipping LLM extraction")
      return
    end
    
    # Skip if already extracted
    if contract.extraction_status == 'completed'
      Rails.logger.info("Contract #{contract_id}: Already extracted, skipping")
      return
    end
    
    # Update status to processing
    contract.update(extraction_status: 'processing')
    
    # Call LLM service
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
    
    # Update contract fields from extracted data
    contract.update(
      # Identification
      title: extracted_data[:title],
      contract_type: extracted_data[:contract_type],
      purchase_subfamily: extracted_data[:purchase_subfamily],
      contract_object: extracted_data[:contract_object],
      detailed_description: extracted_data[:detailed_description],
      contracting_method: extracted_data[:contracting_method],
      public_reference: extracted_data[:public_reference],
      
      # Stakeholders
      contractor_organization_name: extracted_data[:contractor_organization_name],
      contractor_contact_name: extracted_data[:contractor_contact_name],
      contractor_agency_name: extracted_data[:contractor_agency_name],
      client_organization_name: extracted_data[:client_organization_name],
      client_contact_name: extracted_data[:client_contact_name],
      managing_department: extracted_data[:managing_department],
      monitoring_manager: extracted_data[:monitoring_manager],
      contractor_phone: extracted_data[:contractor_phone],
      contractor_email: extracted_data[:contractor_email],
      client_contact_email: extracted_data[:client_contact_email],
      
      # Scope
      covered_sites: extracted_data[:covered_sites] || [],
      covered_buildings: extracted_data[:covered_buildings] || [],
      covered_equipment_types: extracted_data[:covered_equipment_types] || [],
      covered_equipment_list: extracted_data[:covered_equipment_list],
      equipment_count: extracted_data[:equipment_count],
      geographic_areas: extracted_data[:geographic_areas],
      building_names: extracted_data[:building_names],
      floor_levels: extracted_data[:floor_levels],
      specific_zones: extracted_data[:specific_zones],
      technical_lot: extracted_data[:technical_lot],
      equipment_categories: extracted_data[:equipment_categories],
      coverage_description: extracted_data[:coverage_description],
      exclusions: extracted_data[:exclusions],
      special_conditions: extracted_data[:special_conditions],
      scope_notes: extracted_data[:scope_notes],
      
      # Financial
      annual_amount_ht: extracted_data[:annual_amount_ht],
      annual_amount_ttc: extracted_data[:annual_amount_ttc],
      monthly_amount: extracted_data[:monthly_amount],
      billing_method: extracted_data[:billing_method],
      billing_frequency: extracted_data[:billing_frequency],
      payment_terms: extracted_data[:payment_terms],
      revision_conditions: extracted_data[:revision_conditions],
      revision_index: extracted_data[:revision_index],
      revision_frequency: extracted_data[:revision_frequency],
      late_payment_penalties: extracted_data[:late_payment_penalties],
      financial_guarantee: extracted_data[:financial_guarantee],
      deposit_amount: extracted_data[:deposit_amount],
      price_revision_date: parse_date(extracted_data[:price_revision_date]),
      last_amount_update: parse_date(extracted_data[:last_amount_update]),
      budget_code: extracted_data[:budget_code],
      
      # Temporality
      signature_date: parse_date(extracted_data[:signature_date]),
      execution_start_date: parse_date(extracted_data[:execution_start_date]),
      initial_duration_months: extracted_data[:initial_duration_months],
      renewal_duration_months: extracted_data[:renewal_duration_months],
      renewal_count: extracted_data[:renewal_count],
      automatic_renewal: extracted_data[:automatic_renewal],
      notice_period_days: extracted_data[:notice_period_days],
      next_deadline_date: parse_date(extracted_data[:next_deadline_date]),
      last_renewal_date: parse_date(extracted_data[:last_renewal_date]),
      termination_date: parse_date(extracted_data[:termination_date]),
      
      # Services & SLA
      service_nature: extracted_data[:service_nature],
      intervention_frequency: extracted_data[:intervention_frequency],
      intervention_delay_hours: extracted_data[:intervention_delay_hours],
      resolution_delay_hours: extracted_data[:resolution_delay_hours],
      working_hours: extracted_data[:working_hours],
      on_call_24_7: extracted_data[:on_call_24_7],
      sla_percentage: extracted_data[:sla_percentage],
      kpis: extracted_data[:kpis] || [],
      spare_parts_included: extracted_data[:spare_parts_included],
      supplies_included: extracted_data[:supplies_included],
      report_required: extracted_data[:report_required],
      appendix_documents: extracted_data[:appendix_documents] || [],
      
      # Extraction metadata
      extraction_status: 'completed',
      extraction_data: extracted_data,
      extraction_provider: result[:provider],
      extraction_model: result[:model],
      extraction_confidence: result[:confidence],
      extraction_processed_at: Time.current,
      extraction_notes: result[:notes]
    )
    
    # Also update contract_number if it was extracted
    if extracted_data[:contract_number].present? && contract.contract_number.blank?
      contract.update(contract_number: extracted_data[:contract_number])
    end
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
