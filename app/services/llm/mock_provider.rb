# Mock LLM Provider - FREE zero-cost extraction for MVP
# Uses regex patterns to extract data from OCR text
# Perfect for development and demonstration
# Can be swapped for real LLM by just changing config
module Llm
  class MockProvider < BaseProvider
    def extract_from_text(ocr_text)
      return error_result('No OCR text provided') if ocr_text.blank?
      
      # Extract data using regex patterns
      extracted_data = {
        # CATEGORY 1: IDENTIFICATION
        contract_number: extract_contract_number(ocr_text),
        title: extract_title(ocr_text),
        contract_type: extract_contract_type(ocr_text),
        purchase_subfamily: extract_purchase_subfamily(ocr_text),
        contract_object: extract_contract_object(ocr_text),
        detailed_description: extract_description(ocr_text),
        contracting_method: extract_contracting_method(ocr_text),
        public_reference: nil,
        
        # CATEGORY 2: STAKEHOLDERS
        contractor_organization_name: extract_organization(ocr_text, keywords: ['prestataire', 'fournisseur', 'société', 'entreprise']),
        contractor_contact_name: extract_contact(ocr_text),
        contractor_agency_name: nil,
        client_organization_name: extract_organization(ocr_text, keywords: ['client', 'donneur d\'ordre']),
        client_contact_name: nil,
        managing_department: nil,
        monitoring_manager: nil,
        contractor_phone: extract_phone(ocr_text),
        contractor_email: extract_email(ocr_text),
        client_contact_email: nil,
        
        # CATEGORY 3: SCOPE
        covered_sites: [],
        covered_buildings: [],
        covered_equipment_types: extract_equipment_types(ocr_text),
        covered_equipment_list: nil,
        equipment_count: extract_equipment_count(ocr_text),
        geographic_areas: nil,
        building_names: nil,
        floor_levels: nil,
        specific_zones: nil,
        technical_lot: extract_technical_lot(ocr_text),
        equipment_categories: nil,
        coverage_description: nil,
        exclusions: nil,
        special_conditions: nil,
        scope_notes: nil,
        
        # CATEGORY 4: FINANCIAL
        annual_amount_ht: extract_amount(ocr_text, keywords: ['montant annuel HT', 'montant HT', 'total HT']),
        annual_amount_ttc: extract_amount(ocr_text, keywords: ['montant annuel TTC', 'montant TTC', 'total TTC']),
        monthly_amount: extract_amount(ocr_text, keywords: ['montant mensuel', 'mensualité']),
        billing_method: extract_billing_method(ocr_text),
        billing_frequency: extract_billing_frequency(ocr_text),
        payment_terms: extract_payment_terms(ocr_text),
        revision_conditions: nil,
        revision_index: extract_revision_index(ocr_text),
        revision_frequency: nil,
        late_payment_penalties: nil,
        financial_guarantee: nil,
        deposit_amount: nil,
        price_revision_date: nil,
        last_amount_update: nil,
        budget_code: nil,
        
        # CATEGORY 5: TEMPORALITY
        signature_date: extract_date(ocr_text, keywords: ['date de signature', 'signé le', 'signature']),
        execution_start_date: extract_date(ocr_text, keywords: ['date de début', 'début d\'exécution', 'prise d\'effet']),
        initial_duration_months: extract_duration(ocr_text),
        renewal_duration_months: extract_renewal_duration(ocr_text),
        renewal_count: nil,
        automatic_renewal: extract_automatic_renewal(ocr_text),
        notice_period_days: extract_notice_period(ocr_text),
        next_deadline_date: extract_date(ocr_text, keywords: ['échéance', 'prochaine échéance', 'fin de contrat']),
        last_renewal_date: nil,
        termination_date: nil,
        
        # CATEGORY 6: SERVICES & SLA
        service_nature: extract_service_nature(ocr_text),
        intervention_frequency: extract_intervention_frequency(ocr_text),
        intervention_delay_hours: extract_intervention_delay(ocr_text),
        resolution_delay_hours: nil,
        working_hours: extract_working_hours(ocr_text),
        on_call_24_7: extract_on_call(ocr_text),
        sla_percentage: nil,
        kpis: [],
        spare_parts_included: extract_parts_included(ocr_text),
        supplies_included: nil,
        report_required: nil,
        appendix_documents: []
      }
      
      # Calculate confidence based on how many fields were extracted
      confidence = calculate_confidence(extracted_data)
      
      success_result(
        extracted_data,
        confidence: confidence,
        model: 'Mock Provider (Regex)',
        notes: "🎭 Mode Démo - Extraction par expressions régulières. Pour activer l'extraction LLM réelle avec OpenRouter, ajoutez la clé API dans les credentials Rails."
      )
    rescue => e
      error_result("Mock extraction error: #{e.message}")
    end
    
    private
    
    def extract_title(text)
      # Try to get first meaningful line or contract title
      lines = text.split("\n").map(&:strip).reject(&:blank?)
      
      # Skip very short lines and dates
      potential_title = lines.find { |line| line.length > 15 && !line.match?(/^\d/) }
      potential_title&.slice(0, 100)
    end
    
    def extract_contract_type(text)
      types = {
        'maintenance' => 'Contrat de maintenance',
        'nettoyage' => 'Contrat de nettoyage',
        'contrôle' => 'Contrat de contrôle',
        'fourniture' => 'Contrat de fourniture',
        'assurance' => 'Contrat d\'assurance',
        'location' => 'Contrat de location'
      }
      
      types.each do |keyword, contract_type|
        return contract_type if text.downcase.include?(keyword)
      end
      
      'Contrat de prestation'
    end
    
    def extract_purchase_subfamily(text)
      subfamilies = {
        'cvc' => 'CVC (Chauffage, Ventilation, Climatisation)',
        'climatisation' => 'CVC (Chauffage, Ventilation, Climatisation)',
        'chauffage' => 'CVC (Chauffage, Ventilation, Climatisation)',
        'ascenseur' => 'Ascenseurs',
        'électri' => 'Électricité',
        'plomberie' => 'Plomberie',
        'nettoyage' => 'Nettoyage des locaux',
        'sécurité' => 'Sécurité',
        'incendie' => 'Sécurité Incendie'
      }
      
      subfamilies.each do |keyword, subfamily|
        return subfamily if text.downcase.include?(keyword)
      end
      
      nil
    end
    
    def extract_contract_object(text)
      # Look for "Objet:" or "Object:" section
      match = text.match(/objet\s*[:\-]\s*(.{30,200})/i)
      match ? match[1].strip.split(/[.\n]/).first : nil
    end
    
    def extract_description(text)
      # Get a reasonable chunk of text for description
      lines = text.split("\n").map(&:strip).reject(&:blank?)
      lines[1..5]&.join(' ')&.slice(0, 300)
    end
    
    def extract_contracting_method(text)
      return 'Appel d\'offres' if text.downcase.include?('appel d\'offres')
      return 'Marché public' if text.downcase.include?('marché public')
      return 'Gré à gré' if text.downcase.include?('gré à gré')
      nil
    end
    
    def extract_contact(text)
      # Look for name patterns (M./Mme + Name)
      match = text.match(/(M\.|Mme|Monsieur|Madame)\s+([A-Z][a-zéèê]+\s+[A-Z][a-zéèê]+)/i)
      match ? match[2] : nil
    end
    
    def extract_phone(text)
      # French phone patterns
      match = text.match(/0[1-9](?:\s?\d{2}){4}/)
      match ? match[0] : nil
    end
    
    def extract_email(text)
      match = text.match(/[\w\.-]+@[\w\.-]+\.\w+/)
      match ? match[0] : nil
    end
    
    def extract_equipment_types(text)
      equipment = []
      equipment << 'CVC' if text.downcase.match?(/cvc|climatisation|chauffage/)
      equipment << 'Ascenseurs' if text.downcase.include?('ascenseur')
      equipment << 'Électricité' if text.downcase.match?(/électri|éléctri/)
      equipment << 'Plomberie' if text.downcase.include?('plomberie')
      equipment
    end
    
    def extract_equipment_count(text)
      match = text.match(/(\d+)\s+(?:équipements?|appareils?|installations?)/i)
      match ? match[1].to_i : nil
    end
    
    def extract_technical_lot(text)
      return 'CVC' if text.downcase.match?(/cvc|climatisation|chauffage/)
      return 'ELE' if text.downcase.match?(/électri/)
      return 'PLO' if text.downcase.include?('plomberie')
      return 'ASC' if text.downcase.include?('ascenseur')
      return 'SEC' if text.downcase.include?('sécurité')
      nil
    end
    
    def extract_billing_method(text)
      return 'Forfait' if text.downcase.include?('forfait')
      return 'Régie' if text.downcase.include?('régie')
      return 'Mixte' if text.downcase.include?('mixte')
      nil
    end
    
    def extract_billing_frequency(text)
      return 'Mensuelle' if text.downcase.match?(/mensuel|par mois/)
      return 'Trimestrielle' if text.downcase.match?(/trimestriel|par trimestre/)
      return 'Annuelle' if text.downcase.match?(/annuel|par an/)
      nil
    end
    
    def extract_payment_terms(text)
      match = text.match(/(\d+)\s+jours?/i)
      match ? "#{match[1]} jours" : nil
    end
    
    def extract_revision_index(text)
      return 'Index BT01' if text.include?('BT01') || text.include?('bt01')
      return 'Index TP01' if text.include?('TP01') || text.include?('tp01')
      return 'Index INSEE' if text.downcase.include?('insee')
      nil
    end
    
    def extract_duration(text)
      # Look for duration in months or years
      match = text.match(/durée.*?(\d+)\s+(?:mois|ans?)/i)
      if match
        return match[1].to_i if match[0].downcase.include?('mois')
        return match[1].to_i * 12 if match[0].downcase.include?('an')
      end
      nil
    end
    
    def extract_renewal_duration(text)
      match = text.match(/renouvellement.*?(\d+)\s+(?:mois|ans?)/i)
      if match
        return match[1].to_i if match[0].downcase.include?('mois')
        return match[1].to_i * 12 if match[0].downcase.include?('an')
      end
      12 # Default to 12 months if mentioned but no specific duration
    end
    
    def extract_automatic_renewal(text)
      text.downcase.include?('reconduction tacite') || 
      text.downcase.include?('renouvellement automatique')
    end
    
    def extract_notice_period(text)
      match = text.match(/préavis.*?(\d+)\s+(?:jours?|mois)/i)
      return match[1].to_i * 30 if match && match[0].downcase.include?('mois')
      match ? match[1].to_i : nil
    end
    
    def extract_service_nature(text)
      return 'Maintenance préventive et corrective' if text.downcase.include?('maintenance')
      return 'Nettoyage' if text.downcase.include?('nettoyage')
      return 'Contrôle technique' if text.downcase.include?('contrôle')
      nil
    end
    
    def extract_intervention_frequency(text)
      return 'Mensuelle' if text.match?(/1\s+fois?\s+par\s+mois/i)
      return 'Trimestrielle' if text.match?(/(?:1\s+fois?|tous les\s+3\s+mois)\s+par\s+trimestre/i)
      return 'Annuelle' if text.match?(/1\s+fois?\s+par\s+an/i)
      nil
    end
    
    def extract_intervention_delay(text)
      match = text.match(/délai.*?(\d+)\s+heures?/i)
      match ? match[1].to_i : nil
    end
    
    def extract_working_hours(text)
      return '8h-18h du lundi au vendredi' if text.match?(/8.*18|lundi.*vendredi/i)
      return '24h/24 7j/7' if text.match?(/24.*24|7.*7/i)
      nil
    end
    
    def extract_on_call(text)
      text.downcase.match?(/astreinte|24.*24|7.*7/)
    end
    
    def extract_parts_included(text)
      text.downcase.include?('pièces incluses') || 
      text.downcase.include?('fourniture de pièces')
    end
    
    def calculate_confidence(data)
      # Calculate confidence based on extracted fields
      total_fields = data.keys.length
      filled_fields = data.values.count { |v| v.present? && v != [] && v != false }
      
      (filled_fields.to_f / total_fields * 100).round(1)
    end
  end
end
