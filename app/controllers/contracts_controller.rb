require 'ostruct'

class ContractsController < ApplicationController
  def index
    # Mock contracts data for Item 28 - Deletion Confirmation
    @all_contracts = [
      {number: "BAIL-2025-001", title: "Bail commercial Tour A", provider: "SCI Montparnasse", site: "Tour Montparnasse\nTour A", family: "Baux", subfamily: "Commercial", amount: "45,000 €", monthly: "3,750 €", start: "01/01/2025", end: "31/12/2033", termination: "31/12/2031", indexation: "ILC", status: "Actif"},
      {number: "BAIL-2024-089", title: "Bail habitation Bureaux", provider: "Foncière Défense", site: "Campus La Défense", family: "Baux", subfamily: "Habitation", amount: "28,000 €", monthly: "2,333 €", start: "15/03/2024", end: "14/03/2030", termination: "14/03/2029", indexation: "IRL", status: "Actif"},
      {number: "PROP-2023-012", title: "Acquisition Centre Commercial", provider: "SCI Investissement", site: "Centre Commercial Rosny", family: "Actes de propriété", subfamily: "Commercial", amount: "2,500,000 €", surface: "3,200 m²", acquisition: "12/06/2023", notary: "Me. Durand", status: "Actif"},
      {number: "PROP-2024-005", title: "Achat Bureaux Haussmann", provider: "Foncière Paris", site: "Immeuble Haussmann", family: "Actes de propriété", subfamily: "Bureaux", amount: "1,800,000 €", surface: "850 m²", acquisition: "20/01/2024", notary: "Me. Martin", status: "Actif"},
      {number: "CTR-2025-001", title: "Maintenance ascenseurs Tour A", provider: "OTIS France", site: "Tour Montparnasse\nTour A", family: "Maintenance", subfamily: "Ascenseurs", amount: "24,500 €", start: "15/01/2025", end: "14/01/2026", termination: "14/10/2025", status: "Actif"},
      {number: "CTR-2025-002", title: "Nettoyage bureaux quotidien", provider: "Clean Pro Services", site: "Campus La Défense", family: "Nettoyage", subfamily: "Bureaux", amount: "12,800 €", start: "10/01/2025", end: "09/01/2026", termination: "09/10/2025", status: "Actif"},
      {number: "CTR-2024-189", title: "Contrôle électrique réglementaire", provider: "Bureau Veritas", site: "Centre Commercial", family: "Contrôle", subfamily: "Électricité", amount: "8,500 €", start: "05/01/2025", end: "04/01/2026", termination: "04/10/2025", status: "Terminé"},
      {number: "CTR-2025-003", title: "CVC - Maintenance préventive", provider: "Daikin Service", site: "Site Industriel", family: "Maintenance", subfamily: "CVC", amount: "31,200 €", start: "02/01/2025", end: "01/01/2026", termination: "01/10/2025", status: "Actif"},
      {number: "CTR-2024-188", title: "Entretien espaces verts", provider: "Vert Nature SARL", site: "Résidence Le Parc", family: "Nettoyage", subfamily: "Espaces verts", amount: "6,400 €", start: "28/12/2024", end: "27/12/2025", termination: "27/09/2025", status: "Actif"},
      {number: "CTR-2025-004", title: "Contrôle légionelle annuel", provider: "ALS Laboratoires", site: "Campus La Défense", family: "Contrôle", subfamily: "Légionelle", amount: "4,200 €", start: "20/01/2025", end: "19/01/2026", termination: "19/10/2025", status: "En cours"},
      {number: "CTR-2024-187", title: "Maintenance portes automatiques", provider: "Portalp Service", site: "Tour Montparnasse", family: "Maintenance", subfamily: "Portes", amount: "8,900 €", start: "15/12/2024", end: "14/12/2025", termination: "14/09/2025", status: "Actif"},
      {number: "CTR-2025-005", title: "Nettoyage vitrerie extérieure", provider: "Vitres Pro", site: "Immeuble Haussmann", family: "Nettoyage", subfamily: "Vitrerie", amount: "3,600 €", start: "18/01/2025", end: "17/01/2026", termination: "17/10/2025", status: "Actif"},
      {number: "CTR-2024-186", title: "Fourniture électricité", provider: "EDF Entreprises", site: "Tous sites", family: "Énergies", subfamily: "Électricité", amount: "125,000 €", start: "01/01/2025", end: "31/12/2025", termination: "30/09/2025", status: "Actif"},
      {number: "CTR-2025-006", title: "Dératisation / Désinsectisation", provider: "3D Nuisibles", site: "Centre Commercial", family: "Nettoyage", subfamily: "Nuisibles", amount: "2,800 €", start: "12/01/2025", end: "11/01/2026", termination: "11/10/2025", status: "Actif"},
      {number: "CTR-2024-185", title: "Maintenance extincteurs", provider: "Sicli Sécurité", site: "Site Industriel", family: "Sécurité", subfamily: "Incendie", amount: "5,400 €", start: "10/12/2024", end: "09/12/2025", termination: "09/09/2025", status: "Actif"},
      {number: "CTR-2025-007", title: "Climatisation - Entretien", provider: "Climatic Services", site: "Centre Médical", family: "Maintenance", subfamily: "Climatisation", amount: "18,600 €", start: "22/01/2025", end: "21/01/2026", termination: "21/10/2025", status: "Actif"},
      {number: "CTR-2024-184", title: "Assurance multi-risque", provider: "AXA Assurances", site: "Tous sites", family: "Assurance", subfamily: "Multi-risque", amount: "89,000 €", start: "01/01/2025", end: "31/12/2025", termination: "30/09/2025", status: "Actif"},
      {number: "CTR-2025-008", title: "Gardiennage 24/7", provider: "Securitas France", site: "Campus Grenoble", family: "Sécurité", subfamily: "Gardiennage", amount: "156,000 €", start: "01/01/2025", end: "31/12/2025", termination: "30/09/2025", status: "Actif"},
      {number: "CTR-2024-183", title: "Plomberie - Dépannage", provider: "Artiplomb SAS", site: "Parc Roissy", family: "Maintenance", subfamily: "Plomberie", amount: "12,000 €", start: "05/12/2024", end: "04/12/2025", termination: "04/09/2025", status: "Actif"}
    ]
    
    # Group contracts by family
    @leases = @all_contracts.select { |c| c[:family] == "Baux" }
    @property_deeds = @all_contracts.select { |c| c[:family] == "Actes de propriété" }
    @service_contracts = @all_contracts.reject { |c| ["Baux", "Actes de propriété"].include?(c[:family]) }
    
    # Lease-specific data with extended fields
    @lease_data = [
      {number: "BAIL-2025-001", title: "Bail commercial Tour A", provider: "SCI Montparnasse", site: "Tour Montparnasse\nTour A", family: "Baux", subfamily: "Commercial", amount: "45,000 €", monthly: "3,750 €", charges: "450 €", surface: "250 m²", signature: "15/11/2024", start: "01/01/2025", end: "31/12/2033", duration: "108", next_deadline: "31/12/2031", indexation: "ILC", status: "Actif", alert: ""},
      {number: "BAIL-2024-089", title: "Bail habitation Bureaux", provider: "Foncière Défense", site: "Campus La Défense", family: "Baux", subfamily: "Habitation", amount: "28,000 €", monthly: "2,333 €", charges: "280 €", surface: "180 m²", signature: "01/03/2024", start: "15/03/2024", end: "14/03/2030", duration: "72", next_deadline: "14/03/2029", indexation: "IRL", status: "Actif", alert: "Renouvellement proche"}
    ]
    
    # Property deed data with extended fields
    @property_deed_data = [
      {number: "PROP-2023-012", site: "Centre Commercial Rosny", acquisition_date: "12/06/2023", area: "3,200 m²", usage_type: "Commercial", property_type: "Pleine propriété", acquisition_price: "2,500,000 €", current_value: "2,650,000 €", last_update: "15/01/2025", alert: ""},
      {number: "PROP-2024-005", site: "Immeuble Haussmann", acquisition_date: "20/01/2024", area: "850 m²", usage_type: "Bureaux", property_type: "Pleine propriété", acquisition_price: "1,800,000 €", current_value: "1,820,000 €", last_update: "10/01/2025", alert: "Diagnostic manquant"}
    ]
  end

  def show
    # Check if this is a property deed contract (for item 11 testing)
    contract_type = params[:id] == "property-deed" ? "property_deed" : "Maintenance mixte"
    
    @contract = ::OpenStruct.new(
      id: params[:id],
      contract_classification: "initial",
      parent_contract_id: nil,
      pdf_url: "/sample_contract.png",
      contract_number: contract_type == "property_deed" ? "PROP-2023-001" : "CTR-2024-HVAC-001",
      title: contract_type == "property_deed" ? "Acte de Propriété - Tour Montparnasse" : "Maintenance CVC - Climatisation et Chauffage",
      contract_type: contract_type,
      purchase_family: "Maintenance",
      purchase_subfamily: "CVC (Chauffage, Ventilation, Climatisation)",
      status: "active",
      object: "Contrat de maintenance préventive et corrective des installations de chauffage, ventilation et climatisation sur l'ensemble du site, incluant les contrôles réglementaires annuels et le remplacement des consommables.",
      
      # New Identification Fields
      client_contract_reference: "CLI-2024-001",
      supplier_contract_reference: "ENGIE-HVAC-2024-001",
      renewal_mode: "Tacite reconduction",
      currency: "EUR",
      
      # Stakeholders - Client Organization
      client_organization_name: "Société Immobilière PARIS-SUD",
      client_organization_address: "15 Avenue du Général Leclerc, 75014 Paris",
      client_signatory_representative: "Marie Dubois",
      client_signatory_position: "Directrice Générale",
      
      # Stakeholders - Supplier Organization
      contractor_organization: "ENGIE Solutions",
      supplier_organization_address: "1 Place Samuel de Champlain, 92400 Courbevoie",
      supplier_signatory_representative: "Pierre Lambert",
      supplier_signatory_position: "Directeur Commercial",
      contractor_contact: "Jean Dupont",
      contractor_email: "jean.dupont@engie.com",
      contractor_phone: "+33 1 40 06 20 00",
      
      # Contract Management
      contract_manager: "Sophie Martin",
      managing_department: "Services Généraux",
      
      # Scope
      covered_sites: "Siège Social Paris 15ème",
      site_address: "125 Rue de la Convention, 75015 Paris",
      covered_buildings: "Bâtiments A, B et C",
      equipment_type: "Centrales de traitement d'air, Chaudières, Groupes froids, Pompes à chaleur",
      equipment_count: 24,
      contract_scope_spaces: "Bureaux, salles de réunion, espaces communs, parking souterrain",
      equipment_details: "24 équipements dont: 8 CTA (Centrales de Traitement d'Air), 4 chaudières gaz condensation, 6 groupes froids, 4 pompes à chaleur, 2 tours aéroréfrigérantes",
      
      # Financial - Amounts
      initial_annual_amount_excl_tax: 82000.00,
      annual_amount_excl_tax: 85000.00,
      estimated_annual_amount_excl_tax: 87500.00,
      manual_annual_amount_incl_tax: 102000.00,
      annual_amount_incl_tax: 102000.00,
      vat_rate: 20.0,
      
      # Financial - Price Revision
      revision_index: "TP09",
      last_index_publication_date: Date.new(2024, 12, 15),
      last_index_value: 128.5,
      price_indexation_formula: "P = P0 × (TP09n / TP090)",
      minimum_price_revision_percent: 2.0,
      estimated_amount_last_update_date: Date.new(2025, 1, 1),
      manual_ttc_amount_last_update_date: Date.new(2024, 12, 1),
      
      # Financial - Payment & Billing
      billing_method: "Virement bancaire",
      billing_frequency: "Trimestrielle",
      payment_deadline: "30 jours fin de mois",
      term_type: "À terme échu",
      invoicing_support: "Facture électronique via Chorus Pro",
      other_economic_conditions: "Pénalités de retard: 3 fois le taux d'intérêt légal. Indemnité forfaitaire pour frais de recouvrement: 40€",
      off_contract_price_schedules: "Taux horaire technicien: 65€ HT, Taux horaire ingénieur: 95€ HT, Déplacement: 0.50€/km",
      
      # Temporality - Key Dates
      signature_date: Date.new(2024, 1, 15),
      effective_date: Date.new(2024, 2, 1),
      start_date: Date.new(2024, 2, 1),
      effective_end_date: nil,
      annual_price_revision_date: Date.new(2025, 2, 1),
      
      # Temporality - Periods
      first_period_duration: 12,
      initial_duration: 12,
      first_period_expiry_date: Date.new(2025, 1, 31),
      second_period_duration: 12,
      second_period_expiry_date: Date.new(2026, 1, 31),
      third_period_duration: 12,
      third_period_expiry_date: Date.new(2027, 1, 31),
      
      # Temporality - Renewal & Termination
      automatic_renewal: true,
      notice_period_months: 3,
      termination_notice: 90,
      last_tacit_renewal_date: Date.new(2026, 2, 1),
      termination_deadline_before_renewal: Date.new(2026, 10, 31),
      termination_date: nil,
      end_date: Date.new(2027, 1, 31),
      next_deadline: Date.new(2027, 1, 31),
      renewal_duration: 12,
      renewal_count: 2,
      
      # Emergency Services - Business Days
      business_day_breakdown_conditions: "Intervention préventive programmée + dépannage en cas de panne",
      business_day_schedule_hours: "Lundi au Vendredi: 8h00 - 18h00",
      business_day_intervention_delay: "4 heures ouvrées",
      business_day_breakdown_email: "urgence@engie.com",
      business_day_breakdown_phone: "+33 1 40 06 20 99",
      
      # Emergency Services - On-Call
      on_call_breakdown_conditions: "Intervention uniquement en cas d'urgence (panne totale, fuite, risque sécurité)",
      on_call_schedule_hours: "7j/7, 24h/24 (nuits, week-ends, jours fériés)",
      on_call_intervention_delay: "2 heures",
      on_call_breakdown_email: "astreinte@engie.com",
      on_call_breakdown_phone: "+33 6 12 34 56 78",
      
      # Services & SLA
      service_nature: "Maintenance préventive trimestrielle incluant : vérification des installations, nettoyage des filtres, contrôle des fluides frigorigènes, réglage des paramètres. Maintenance corrective en cas de panne avec astreinte 24/7.",
      intervention_frequency: "Trimestrielle pour préventif",
      intervention_delay: 4,
      resolution_delay: 24,
      working_hours: "8h-18h du lundi au vendredi, astreinte 24/7 pour urgences",
      on_call_24_7: true,
      service_level: 98.5,
      spare_parts_included: false,
      intervention_report_required: true,
      kpi: "Taux de disponibilité > 98%, Temps de réponse < 4h, Satisfaction client > 95%",
      
      # Notes
      notes: "Contrat renouvelé pour la 3ème fois. Prestataire historique avec une excellente connaissance du parc. Prévoir une renégociation tarifaire avant la prochaine reconduction.",
      
      # Item 11: Property Deed specific fields (only shown when contract_type == 'property_deed')
      property_deed_site: "Tour Montparnasse",
      property_deed_acquisition_date: "15/03/2023",
      property_deed_area: 2500,
      property_deed_usage_type: "Bureau / Commercial",
      property_deed_type: "Pleine Propriété",
      property_deed_acquisition_price: 4500000.00,
      property_deed_current_value: 5200000.00,
      property_deed_value_update_date: "01/01/2025",
      property_deed_alerts: "Annexe diagnostic manquant",
      
      # Item 12: Data Source Tracking fields
      created_by: "John Wick",
      created_at: "02/05/2026 à 14:30",
      updated_by: "Marie Dubois", 
      updated_at: "15/11/2026 à 09:15",
      import_source: "Excel",
      import_date: "01/05/2026 à 10:00",
      import_user: "Admin"
    )
    
    # Mock related contracts (amendments and framework agreements)
    @amendments = [
      OpenStruct.new(
        id: "avenant-1",
        contract_number: "AVN-2024-001",
        title: "Avenant N°1 - Extension périmètre",
        signature_date: Date.new(2024, 6, 15),
        status: "active"
      ),
      OpenStruct.new(
        id: "avenant-2",
        contract_number: "AVN-2024-002",
        title: "Avenant N°2 - Révision tarifaire",
        signature_date: Date.new(2024, 9, 1),
        status: "active"
      )
    ]
    
    @framework_agreements = [
      OpenStruct.new(
        id: "framework-1",
        contract_number: "ACC-2024-001",
        title: "Accord cadre - Prestations exceptionnelles",
        signature_date: Date.new(2024, 3, 1),
        status: "active"
      )
    ]
  end

  def new
    @contract = ::OpenStruct.new(
      contract_classification: "",
      parent_contract_id: "",
      pdf_url: nil,
      contract_number: "",
      title: "",
      contract_type: "",
      purchase_family: "",
      purchase_subfamily: "",
      status: "active",
      object: "",
      
      # Stakeholders
      contractor_organization: "",
      contractor_contact: "",
      contractor_email: "",
      contractor_phone: "",
      contract_manager: "",
      managing_department: "",
      
      # Scope
      covered_sites: "",
      covered_buildings: "",
      equipment_type: "",
      equipment_count: nil,
      geographic_areas: "",
      
      # Financial
      annual_amount_excl_tax: nil,
      annual_amount_incl_tax: nil,
      billing_method: "",
      billing_frequency: "",
      revision_index: "",
      revision_conditions: "",
      
      # Temporality
      signature_date: nil,
      start_date: nil,
      end_date: nil,
      initial_duration: nil,
      renewal_duration: nil,
      renewal_count: nil,
      automatic_renewal: false,
      termination_notice: nil,
      next_deadline: nil,
      
      # Services & SLA
      service_nature: "",
      intervention_frequency: "",
      intervention_delay: nil,
      resolution_delay: nil,
      working_hours: "",
      on_call_24_7: false,
      service_level: nil,
      spare_parts_included: false,
      intervention_report_required: false,
      kpi: "",
      
      # Notes
      notes: ""
    )
  end

  def create
    @contract = Contract.new(contract_params)
    @contract.organization_id = current_user.organization_id if current_user
    
    if @contract.save
      redirect_to contracts_path, notice: "Contrat créé avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @contract = ::OpenStruct.new(
      id: params[:id],
      contract_classification: "initial",
      parent_contract_id: "",
      pdf_url: "/sample_contract.png",
      contract_number: "CTR-2024-HVAC-001",
      title: "Maintenance CVC - Climatisation et Chauffage",
      contract_type: "Maintenance mixte",
      purchase_family: "Maintenance",
      purchase_subfamily: "CVC (Chauffage, Ventilation, Climatisation)",
      status: "active",
      object: "Contrat de maintenance préventive et corrective des installations de chauffage, ventilation et climatisation sur l'ensemble du site, incluant les contrôles réglementaires annuels et le remplacement des consommables.",
      
      # Stakeholders
      contractor_organization: "ENGIE Solutions",
      contractor_contact: "Jean Dupont",
      contractor_email: "jean.dupont@engie.com",
      contractor_phone: "+33 1 40 06 20 00",
      contract_manager: "Sophie Martin",
      managing_department: "Services Généraux",
      
      # Scope
      covered_sites: "Tous les sites du portefeuille",
      covered_buildings: "Bâtiments A, B et C",
      equipment_type: "Centrales de traitement d'air, Chaudières, Groupes froids, Pompes à chaleur",
      equipment_count: 24,
      geographic_areas: "Île-de-France, principalement Paris 15ème",
      
      # Financial
      annual_amount_excl_tax: 85000.00,
      annual_amount_incl_tax: 102000.00,
      billing_method: "Prix forfaitaire",
      billing_frequency: "Trimestrielle",
      revision_index: "TP09",
      revision_conditions: "Révision annuelle selon indice TP09 publié par l'INSEE",
      
      # Temporality
      signature_date: Date.new(2024, 1, 15),
      start_date: Date.new(2024, 2, 1),
      end_date: Date.new(2027, 1, 31),
      initial_duration: 36,
      renewal_duration: 12,
      renewal_count: 2,
      automatic_renewal: true,
      termination_notice: 90,
      next_deadline: Date.new(2027, 1, 31),
      
      # Services & SLA
      service_nature: "Maintenance préventive trimestrielle incluant : vérification des installations, nettoyage des filtres, contrôle des fluides frigorigènes, réglage des paramètres. Maintenance corrective en cas de panne avec astreinte 24/7.",
      intervention_frequency: "Trimestrielle pour préventif",
      intervention_delay: 4,
      resolution_delay: 24,
      working_hours: "8h-18h du lundi au vendredi, astreinte 24/7 pour urgences",
      on_call_24_7: true,
      service_level: 98.5,
      spare_parts_included: false,
      intervention_report_required: true,
      kpi: "Taux de disponibilité > 98%, Temps de réponse < 4h, Satisfaction client > 95%",
      
      # Notes
      notes: "Contrat renouvelé pour la 3ème fois. Prestataire historique avec une excellente connaissance du parc. Prévoir une renégociation tarifaire avant la prochaine reconduction."
    )
  end

  def update
    @contract = Contract.find(params[:id])
    
    if @contract.update(contract_params)
      redirect_to contract_path(@contract.id), notice: "Contrat mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Handle contract deletion
    redirect_to contracts_path, notice: "Contrat supprimé avec succès"
  end

  def pdf
    # Renders contracts/pdf.html.erb or generates PDF
  end

  def validate
    @contract = Contract.find(params[:id])
    
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Check if contract has completed extraction
    unless @contract.extraction_completed?
      redirect_to contract_path(@contract), alert: "L'extraction des données doit être terminée avant la validation"
      return
    end
    
    # Mark as in progress if still pending
    if @contract.validation_pending?
      @contract.update(validation_status: 'in_progress')
    end
  end

  def confirm_validation
    @contract = Contract.find(params[:id])
    
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    # Update contract with validated data
    if @contract.update(validation_params)
      # Mark as validated
      @contract.update(
        validation_status: 'validated',
        validated_at: Time.current,
        validated_by: "#{current_user.first_name} #{current_user.last_name}".strip
      )
      
      redirect_to contract_path(@contract), notice: "Contrat validé avec succès"
    else
      render :validate, status: :unprocessable_entity
    end
  end

  def compare
    # Renders contracts/compare.html.erb
  end

  def upload
    # Renders contracts/upload.html.erb
  end

  def process_upload
    # Handle contract upload
    redirect_to contracts_path, notice: "Contrat importé avec succès"
  end

  def delete_pdf
    @contract = Contract.find(params[:id])
    
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.pdf_document.attached?
      @contract.pdf_document.purge
      redirect_to edit_contract_path(@contract), notice: "PDF supprimé avec succès"
    else
      redirect_to edit_contract_path(@contract), alert: "Aucun PDF à supprimer"
    end
  end

  def retry_ocr
    @contract = Contract.find(params[:id])
    
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.retry_ocr!
      redirect_to contract_path(@contract), notice: "Extraction OCR relancée avec succès"
    else
      redirect_to contract_path(@contract), alert: "Impossible de relancer l'extraction OCR. Aucun PDF attaché."
    end
  end
  
  def retry_extraction
    @contract = Contract.find(params[:id])
    
    # Check authorization
    unless @contract.organization_id == current_user.organization_id
      redirect_to contracts_path, alert: "Accès non autorisé"
      return
    end
    
    if @contract.retry_extraction!
      redirect_to contract_path(@contract), notice: "Extraction LLM relancée avec succès"
    else
      redirect_to contract_path(@contract), alert: "Impossible de relancer l'extraction. OCR non complété."
    end
  end

  private
  
  def validation_params
    # Get all the extracted fields that can be validated/corrected
    params.require(:contract).permit(
      :title,
      :contract_object,
      :contract_type,
      :purchase_subfamily,
      :detailed_description,
      :contracting_method,
      :public_reference,
      :contractor_organization_name,
      :contractor_contact_name,
      :contractor_agency_name,
      :client_organization_name,
      :client_contact_name,
      :managing_department,
      :monitoring_manager,
      :contractor_phone,
      :contractor_email,
      :client_contact_email,
      :equipment_count,
      :geographic_areas,
      :building_names,
      :floor_levels,
      :specific_zones,
      :technical_lot,
      :equipment_categories,
      :coverage_description,
      :exclusions,
      :special_conditions,
      :scope_notes,
      :annual_amount_ht,
      :annual_amount_ttc,
      :monthly_amount,
      :billing_method,
      :billing_frequency,
      :payment_terms,
      :revision_conditions,
      :revision_index,
      :revision_frequency,
      :late_payment_penalties,
      :financial_guarantee,
      :deposit_amount,
      :price_revision_date,
      :last_amount_update,
      :budget_code,
      :signature_date,
      :execution_start_date,
      :initial_duration_months,
      :renewal_duration_months,
      :renewal_count,
      :automatic_renewal,
      :notice_period_days,
      :next_deadline_date,
      :last_renewal_date,
      :termination_date,
      :service_nature,
      :intervention_frequency,
      :intervention_delay_hours,
      :resolution_delay_hours,
      :working_hours,
      :on_call_24_7,
      :sla_percentage,
      :spare_parts_included,
      :supplies_included,
      :report_required,
      :validation_notes,
      covered_sites: [],
      covered_buildings: [],
      covered_equipment_types: [],
      kpis: [],
      appendix_documents: []
    )
  end

  def contract_params
    params.require(:contract).permit(
      :contract_classification,
      :parent_contract_id,
      :pdf_document,
      :contract_number,
      :title,
      :contract_type,
      :purchase_family,
      :purchase_subfamily,
      :status,
      :object,
      :contractor_organization,
      :contractor_contact,
      :contractor_email,
      :contractor_phone,
      :contract_manager,
      :managing_department,
      :site_id,
      :covered_sites,
      :covered_buildings,
      :equipment_type,
      :equipment_count,
      :geographic_areas,
      :annual_amount_excl_tax,
      :annual_amount_incl_tax,
      :billing_method,
      :billing_frequency,
      :revision_index,
      :revision_conditions,
      :signature_date,
      :start_date,
      :end_date,
      :initial_duration,
      :renewal_duration,
      :renewal_count,
      :automatic_renewal,
      :termination_notice,
      :next_deadline,
      :service_nature,
      :intervention_frequency,
      :intervention_delay,
      :resolution_delay,
      :working_hours,
      :on_call_24_7,
      :service_level,
      :spare_parts_included,
      :intervention_report_required,
      :kpi,
      :notes
    )
  end
end
