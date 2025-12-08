module Technician
  class ContractsController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_technician!
    
    def index
      # Technicians can view all contracts in their organization (read-only)
      @contracts = Contract.by_organization(current_user.organization_id)
                          .includes(:site, :contractor_organization)
                          .order(created_at: :desc)
      
      # Apply filters if present
      apply_filters if params[:search].present? || params[:site_id].present? || 
                      params[:family].present? || params[:status].present? || 
                      params[:contractor].present?
      
      # Paginate results (15 per page)
      @contracts = @contracts.page(params[:page]).per(15)
    end

    def show
      @contract = OpenStruct.new(
        id: params[:id],
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

    def pdf
      @contract = Contract.by_organization(current_user.organization_id).find(params[:id])
      # Renders technician/contracts/pdf.html.erb or generates PDF
      respond_to do |format|
        format.html
        format.pdf do
          redirect_to rails_blob_path(@contract.pdf_document, disposition: "inline")
        end
      end
    end
    
    private
    
    def ensure_technician!
      unless current_user&.technician?
        redirect_to root_path, alert: "Accès non autorisé"
      end
    end
    
    def apply_filters
      # Search by contract number or title
      if params[:search].present?
        @contracts = @contracts.where(
          "contract_number ILIKE ? OR title ILIKE ?", 
          "%#{params[:search]}%", 
          "%#{params[:search]}%"
        )
      end
      
      # Filter by site
      if params[:site_id].present?
        @contracts = @contracts.where(site_id: params[:site_id])
      end
      
      # Filter by contract family
      if params[:family].present?
        @contracts = @contracts.where("contract_family ILIKE ?", "%#{params[:family]}%")
      end
      
      # Filter by status
      if params[:status].present?
        status_map = {
          'Actif' => 'active',
          'En cours' => 'pending',
          'Terminé' => 'expired'
        }
        @contracts = @contracts.where(status: status_map[params[:status]] || params[:status])
      end
      
      # Filter by contractor
      if params[:contractor].present?
        @contracts = @contracts.where(
          "contractor_organization_name ILIKE ?", 
          "%#{params[:contractor]}%"
        )
      end
    end
  end
end
