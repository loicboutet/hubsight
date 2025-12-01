require 'ostruct'

module Admin
  class PriceReferencesController < ApplicationController
    layout 'admin'
    
    # GET /admin/price_references
    def index
      @price_references = [
        OpenStruct.new(
          id: 1,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance CVC",
          equipment_type: "Climatisation",
          service_type: "Service Annuel",
          location: "Île-de-France",
          city: "Paris",
          reference_price: 1200.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2025, 1, 15),
          technical_characteristics: "Puissance: 10kW, Couverture: 200m², Fréquence: Annuelle"
        ),
        OpenStruct.new(
          id: 2,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance Ascenseurs",
          equipment_type: "Ascenseur Passagers",
          service_type: "Inspection Trimestrielle",
          location: "Île-de-France",
          city: "Paris",
          reference_price: 850.00,
          unit: "per_quarter",
          currency: "EUR",
          updated_at: Date.new(2024, 12, 10),
          technical_characteristics: "Capacité: 8 personnes, Vitesse: 1m/s"
        ),
        OpenStruct.new(
          id: 3,
          contract_family: "Contrôles Techniques",
          contract_sub_family: "Sécurité Incendie",
          equipment_type: "Extincteurs",
          service_type: "Inspection Annuelle",
          location: "Provence-Alpes-Côte d'Azur",
          city: "Marseille",
          reference_price: 450.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 11, 5),
          technical_characteristics: "Nombre d'extincteurs: 20-30 unités"
        ),
        OpenStruct.new(
          id: 4,
          contract_family: "Nettoyage et Hygiène",
          contract_sub_family: "Nettoyage Bureaux",
          equipment_type: "Bureaux Standards",
          service_type: "Nettoyage Quotidien",
          location: "Île-de-France",
          city: "Paris",
          reference_price: 25.00,
          unit: "per_sqm_month",
          currency: "EUR",
          updated_at: Date.new(2025, 1, 20),
          technical_characteristics: "Surface: 500-1000m², Fréquence: 5j/7"
        ),
        OpenStruct.new(
          id: 5,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance Électrique",
          equipment_type: "Tableau Électrique",
          service_type: "Maintenance Préventive",
          location: "Auvergne-Rhône-Alpes",
          city: "Lyon",
          reference_price: 680.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 12, 15),
          technical_characteristics: "Puissance: 100kVA, Vérification annuelle"
        ),
        OpenStruct.new(
          id: 6,
          contract_family: "Contrôles Techniques",
          contract_sub_family: "Contrôle Climatisation",
          equipment_type: "Système CVC Centralisé",
          service_type: "Contrôle Réglementaire",
          location: "Occitanie",
          city: "Toulouse",
          reference_price: 950.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 10, 28),
          technical_characteristics: "Puissance > 70kW, Contrôle annuel obligatoire"
        ),
        OpenStruct.new(
          id: 7,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance Plomberie",
          equipment_type: "Chaudière Collective",
          service_type: "Entretien Annuel",
          location: "Nouvelle-Aquitaine",
          city: "Bordeaux",
          reference_price: 420.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 11, 12),
          technical_characteristics: "Puissance: 50kW, Entretien réglementaire"
        ),
        OpenStruct.new(
          id: 8,
          contract_family: "Assurances",
          contract_sub_family: "Assurance Dommage Ouvrage",
          equipment_type: "Bâtiment Tertiaire",
          service_type: "Police Annuelle",
          location: "Île-de-France",
          city: "Paris",
          reference_price: 15000.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2025, 1, 5),
          technical_characteristics: "Surface: 5000m², Valeur assurée: 10M€"
        ),
        OpenStruct.new(
          id: 9,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance Portes Automatiques",
          equipment_type: "Portes Coulissantes",
          service_type: "Maintenance Semestrielle",
          location: "Hauts-de-France",
          city: "Lille",
          reference_price: 320.00,
          unit: "per_semester",
          currency: "EUR",
          updated_at: Date.new(2024, 12, 8),
          technical_characteristics: "Nombre de portes: 4-6 unités"
        ),
        OpenStruct.new(
          id: 10,
          contract_family: "Contrôles Techniques",
          contract_sub_family: "Contrôle Électrique",
          equipment_type: "Installation Électrique",
          service_type: "Vérification Réglementaire",
          location: "Grand Est",
          city: "Strasbourg",
          reference_price: 580.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 11, 22),
          technical_characteristics: "Surface: 2000m², Installation complète"
        ),
        OpenStruct.new(
          id: 11,
          contract_family: "Nettoyage et Hygiène",
          contract_sub_family: "Nettoyage Vitres",
          equipment_type: "Façades Vitrées",
          service_type: "Nettoyage Trimestriel",
          location: "Île-de-France",
          city: "La Défense",
          reference_price: 18.00,
          unit: "per_sqm_quarter",
          currency: "EUR",
          updated_at: Date.new(2024, 12, 1),
          technical_characteristics: "Surface vitrée: 500-1000m²"
        ),
        OpenStruct.new(
          id: 12,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance VMC",
          equipment_type: "Ventilation Double Flux",
          service_type: "Maintenance Annuelle",
          location: "Pays de la Loire",
          city: "Nantes",
          reference_price: 540.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 10, 15),
          technical_characteristics: "Débit: 5000m³/h, Nettoyage filtres"
        ),
        OpenStruct.new(
          id: 13,
          contract_family: "Contrôles Techniques",
          contract_sub_family: "Contrôle Ascenseurs",
          equipment_type: "Ascenseur",
          service_type: "Contrôle Technique Quinquennal",
          location: "Provence-Alpes-Côte d'Azur",
          city: "Nice",
          reference_price: 1200.00,
          unit: "per_control",
          currency: "EUR",
          updated_at: Date.new(2024, 9, 20),
          technical_characteristics: "Contrôle réglementaire obligatoire"
        ),
        OpenStruct.new(
          id: 14,
          contract_family: "Maintenance",
          contract_sub_family: "Maintenance Groupe Électrogène",
          equipment_type: "Groupe de Secours",
          service_type: "Maintenance Préventive",
          location: "Bretagne",
          city: "Rennes",
          reference_price: 890.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2024, 11, 8),
          technical_characteristics: "Puissance: 250kVA, 2 visites/an"
        ),
        OpenStruct.new(
          id: 15,
          contract_family: "Assurances",
          contract_sub_family: "Assurance Responsabilité Civile",
          equipment_type: "Activité Tertiaire",
          service_type: "Police Annuelle",
          location: "Île-de-France",
          city: "Paris",
          reference_price: 2500.00,
          unit: "per_year",
          currency: "EUR",
          updated_at: Date.new(2025, 1, 10),
          technical_characteristics: "Plafond garantie: 5M€"
        )
      ]
      
      @total_references = @price_references.length
      @contract_families_count = @price_references.map(&:contract_family).uniq.length
      @last_update = @price_references.map(&:updated_at).max
    end
    
    # GET /admin/price_references/:id
    def show
    end
    
    # GET /admin/price_references/new
    def new
      @price_reference = OpenStruct.new
      @price_reference.define_singleton_method(:persisted?) { false }
    end
    
    # POST /admin/price_references
    def create
    end
    
    # GET /admin/price_references/:id/edit
    def edit
      @price_reference = OpenStruct.new(
        contract_family: "maintenance",
        contract_sub_family: "Maintenance CVC",
        equipment_type: "Climatisation",
        service_type: "Service Annuel",
        technical_characteristics: "Puissance: 10kW, Couverture: 200m², Fréquence: Trimestrielle",
        reference_price: "1200.00",
        unit: "per_year",
        currency: "EUR",
        location: "Île-de-France",
        city: "Paris",
        notes: "Basé sur une étude de marché réalisée au T1 2025. Inclut les conditions standard de contrat de maintenance."
      )
      @price_reference.define_singleton_method(:persisted?) { true }
    end
    
    # PATCH/PUT /admin/price_references/:id
    def update
    end
    
    # DELETE /admin/price_references/:id
    def destroy
    end
    
    # GET /admin/price_references/import
    def import
    end
    
    # POST /admin/price_references/import
    def process_import
    end
    
    # GET /admin/price_references/export
    def export
    end
  end
end
