require 'ostruct'

class ContractsController < ApplicationController
  def index
    # Renders contracts/index.html.erb
  end

  def show
    @contract = ::OpenStruct.new(
      id: params[:id],
      contract_classification: "initial",
      parent_contract_id: nil,
      pdf_url: "/sample_contract.png",
      contract_number: "CTR-2024-HVAC-001",
      title: "Maintenance CVC - Climatisation et Chauffage",
      contract_type: "Maintenance mixte",
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
      notes: "Contrat renouvelé pour la 3ème fois. Prestataire historique avec une excellente connaissance du parc. Prévoir une renégociation tarifaire avant la prochaine reconduction."
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
    # Handle contract creation
    redirect_to contracts_path, notice: "Contrat créé avec succès"
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
    # Handle contract update
    redirect_to contract_path(params[:id]), notice: "Contrat mis à jour avec succès"
  end

  def destroy
    # Handle contract deletion
    redirect_to contracts_path, notice: "Contrat supprimé avec succès"
  end

  def pdf
    # Renders contracts/pdf.html.erb or generates PDF
  end

  def validate
    # Mock contract being validated
    @contract = ::OpenStruct.new(
      id: params[:id],
      contract_number: "AX000",
      pdf_url: "/sample_contract.png"
    )
    
    # Mock extracted fields with confidence scores (matching screenshot)
    @extracted_fields = [
      {
        label: "Objet",
        value: "Contrat de maintenance et entretien des installations de plomberie, de climatisation et de ventilation",
        confidence: 0.99
      },
      {
        label: "Site",
        value: "Résidence AMARAGGI, 11, Boulevard Sérurier, 75019 PARIS",
        confidence: 1.00
      },
      {
        label: "Numéro de contrat",
        value: "AX000",
        confidence: 1.00
      },
      {
        label: "Le fournisseur",
        value: "AXONE",
        confidence: 0.98
      },
      {
        label: "Le client",
        value: "FONDATION CASIP-COJASOR",
        confidence: 1.00
      },
      {
        label: "Date de prise d'effet du contrat",
        value: "01/01/2024",
        confidence: 1.00
      },
      {
        label: "Durée du contrat",
        value: "1 an",
        confidence: 1.00
      },
      {
        label: "Clause de renouvellement",
        value: "Tacite",
        confidence: 1.00
      },
      {
        label: "Durée de renouvellement",
        value: "1",
        confidence: 1.00
      },
      {
        label: "Nature des prestations prévues au contrat",
        value: "Maintenance préventive et curative des équipements du réseau de climatisations, chauffage et ventilation des locaux, incluant visites mensuelles, semestrielles et annuelles selon les équipements, dépannage sous 48h, astreinte, assistance technique, état des lieux et rapport de prise en charge.",
        confidence: 0.95
      },
      {
        label: "Procédure de dépannage",
        value: "En cas de panne, intervention sous 48h après appel du client au 01.69.34.69.13 ou par mail à maintenance@axone-idf.com, du lundi au vendredi de 8h30 à 17h30. Déplacements et temps d'intervention inclus, fournitures facturées en sus.",
        confidence: 0.97
      },
      {
        label: "Astreinte",
        value: "Intervention sous 48h après appel du client, 7j/7, 365 jours par an : du lundi au vendredi de 17h30 à 8h30, samedi et dimanche 24h/24. Abonnement inclus, interventions et déplacements facturés en sus au tarif de régie, fournitures en sus.",
        confidence: 0.97
      }
    ]
  end

  def confirm_validation
    # Handle contract validation
    redirect_to contract_path(params[:id]), notice: "Contrat validé avec succès"
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
end
