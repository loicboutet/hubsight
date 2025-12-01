require 'prawn'
require 'prawn/table'

class ContractPdfGenerator
  include ActionView::Helpers::NumberHelper
  
  # Purple/Coral color scheme matching app theme
  COLORS = {
    primary: '667EEA',      # Purple
    secondary: '764BA2',    # Dark purple
    coral: 'FF6B6B',        # Coral/Red
    emergency: 'DC2626',    # Emergency red
    success: '10B981',      # Green
    warning: 'F59E0B',      # Orange
    gray: '6B7280',         # Gray
    light_gray: 'F3F4F6'    # Light gray
  }
  
  def initialize(contract)
    @contract = contract
    @pdf = Prawn::Document.new(page_size: 'A4', margin: 40)
  end
  
  def generate
    add_header
    add_emergency_contacts
    add_contract_identification
    add_stakeholders
    add_scope
    add_financial_aspects
    add_temporality
    add_services_sla
    add_footer
    
    @pdf.render
  end
  
  private
  
  def add_header
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      # Gradient-style header background
      @pdf.fill_color COLORS[:primary]
      @pdf.fill_rectangle [0, @pdf.cursor], @pdf.bounds.width, 80
      
      @pdf.fill_color 'FFFFFF'
      @pdf.move_down 15
      @pdf.font('Helvetica-Bold', size: 20) do
        @pdf.text 'FICHE RÉCAPITULATIVE DE CONTRAT', align: :center
      end
      
      @pdf.move_down 5
      @pdf.font('Helvetica', size: 10) do
        @pdf.text @contract.organization&.name || 'HubSight', align: :center
      end
      
      @pdf.move_down 20
      @pdf.fill_color '000000'
    end
    
    @pdf.move_down 30
    
    # Contract summary box
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width, height: 60) do
      @pdf.fill_color COLORS[:light_gray]
      @pdf.fill_rectangle [0, @pdf.cursor], @pdf.bounds.width, 60
      @pdf.fill_color '000000'
      
      @pdf.move_down 10
      @pdf.indent(20) do
        @pdf.font('Helvetica-Bold', size: 14) do
          @pdf.text @contract.title || @contract.contract_number
        end
        @pdf.move_down 5
        @pdf.font('Helvetica', size: 10) do
          @pdf.text "Contrat N° #{@contract.contract_number}"
          @pdf.text "Site: #{@contract.site&.name || @contract.covered_sites || 'Non spécifié'}"
        end
      end
    end
    
    @pdf.move_down 20
  end
  
  def add_emergency_contacts
    return unless has_emergency_info?
    
    section_header('🚨 CONTACTS D\'URGENCE', COLORS[:emergency])
    
    @pdf.bounding_box([0, @pdf.cursor], width: @pdf.bounds.width) do
      @pdf.fill_color 'FEE2E2'  # Light red background
      @pdf.fill_rectangle [0, @pdf.cursor], @pdf.bounds.width, @pdf.cursor - 20
      @pdf.fill_color '000000'
      
      @pdf.move_down 15
      @pdf.indent(15) do
        # Business hours
        if @contract.business_day_breakdown_phone.present?
          @pdf.font('Helvetica-Bold', size: 11) do
            @pdf.fill_color COLORS[:coral]
            @pdf.text 'Jours Ouvrés'
            @pdf.fill_color '000000'
          end
          @pdf.move_down 5
          
          contact_row('Planning', @contract.business_day_schedule_hours)
          contact_row('Délai d\'intervention', @contract.business_day_intervention_delay)
          
          @pdf.font('Helvetica-Bold', size: 12) do
            @pdf.fill_color COLORS[:emergency]
            @pdf.text "☎ #{@contract.business_day_breakdown_phone}"
            @pdf.fill_color '000000'
          end
          
          if @contract.business_day_breakdown_email.present?
            @pdf.font('Helvetica', size: 9) do
              @pdf.text "✉ #{@contract.business_day_breakdown_email}"
            end
          end
          
          @pdf.move_down 10
        end
        
        # On-call / Astreinte
        if @contract.on_call_breakdown_phone.present?
          @pdf.font('Helvetica-Bold', size: 11) do
            @pdf.fill_color COLORS[:coral]
            @pdf.text 'Astreinte (24/7)'
            @pdf.fill_color '000000'
          end
          @pdf.move_down 5
          
          contact_row('Planning', @contract.on_call_schedule_hours)
          contact_row('Délai d\'intervention', @contract.on_call_intervention_delay)
          
          @pdf.font('Helvetica-Bold', size: 12) do
            @pdf.fill_color COLORS[:emergency]
            @pdf.text "☎ #{@contract.on_call_breakdown_phone}"
            @pdf.fill_color '000000'
          end
          
          if @contract.on_call_breakdown_email.present?
            @pdf.font('Helvetica', size: 9) do
              @pdf.text "✉ #{@contract.on_call_breakdown_email}"
            end
          end
        end
        
        @pdf.move_down 10
      end
    end
    
    @pdf.move_down 15
  end
  
  def add_contract_identification
    section_header('📋 IDENTIFICATION DU CONTRAT', COLORS[:primary])
    
    data = [
      ['Numéro', @contract.contract_number || '—'],
      ['Type', @contract.contract_type&.humanize || '—'],
      ['Famille d\'Achats', @contract.contract_family || '—'],
      ['Sous-famille', @contract.purchase_subfamily || '—'],
      ['Statut', format_status(@contract.status)],
      ['Devise', @contract.currency || 'EUR']
    ]
    
    render_info_table(data)
  end
  
  def add_stakeholders
    section_header('👥 PARTIES PRENANTES', COLORS[:primary])
    
    @pdf.font('Helvetica-Bold', size: 10) do
      @pdf.fill_color COLORS[:coral]
      @pdf.text 'Prestataire / Fournisseur'
      @pdf.fill_color '000000'
    end
    @pdf.move_down 5
    
    data = [
      ['Organisation', @contract.contractor_organization || @contract.contractor_organization_name || '—'],
      ['Contact', @contract.contractor_contact || @contract.contractor_contact_name || '—'],
      ['Email', @contract.contractor_email || '—'],
      ['Téléphone', @contract.contractor_phone || '—']
    ]
    
    render_info_table(data)
  end
  
  def add_scope
    section_header('🎯 PÉRIMÈTRE', COLORS[:primary])
    
    data = [
      ['Site(s) Couvert(s)', @contract.site&.name || @contract.covered_sites || '—'],
      ['Bâtiment(s)', @contract.covered_buildings || '—'],
      ['Type(s) d\'Équipement', @contract.equipment_types || '—'],
      ['Nombre d\'Équipements', @contract.equipment_count&.to_s || '—']
    ]
    
    render_info_table(data)
    
    # Equipment list if site is specified
    if @contract.site_id.present?
      add_equipment_list
    end
  end
  
  def add_equipment_list
    equipment = Equipment.where(site_id: @contract.site_id)
                        .includes(:space, :level, :building)
                        .order('buildings.name, levels.level_number, spaces.name, equipment.name')
                        .limit(20)
    
    return if equipment.empty?
    
    @pdf.move_down 10
    @pdf.font('Helvetica-Bold', size: 10) do
      @pdf.text 'Équipements du Site (extrait)'
    end
    @pdf.move_down 5
    
    table_data = [['Type', 'Nom', 'Localisation']]
    
    equipment.each do |eq|
      location = [eq.building&.name, eq.level&.name, eq.space&.name].compact.join(' > ')
      table_data << [
        eq.equipment_type&.truncate(20) || '—',
        eq.name&.truncate(30) || '—',
        location.truncate(40)
      ]
    end
    
    @pdf.table(table_data, 
      header: true,
      width: @pdf.bounds.width,
      cell_style: { size: 8, padding: 5 },
      row_colors: ['FFFFFF', COLORS[:light_gray]]
    ) do
      row(0).font_style = :bold
      row(0).background_color = COLORS[:primary]
      row(0).text_color = 'FFFFFF'
    end
    
    if equipment.count == 20
      @pdf.move_down 5
      @pdf.font('Helvetica', size: 8) do
        @pdf.text '(Liste limitée aux 20 premiers équipements)', style: :italic, color: COLORS[:gray]
      end
    end
    
    @pdf.move_down 10
  end
  
  def add_financial_aspects
    section_header('💰 ASPECTS FINANCIERS', COLORS[:primary])
    
    annual_amount = @contract.annual_amount || @contract.annual_amount_excl_tax
    
    data = [
      ['Montant Annuel HT', format_currency(annual_amount)],
      ['Montant Annuel TTC', format_currency(@contract.annual_amount_incl_tax)],
      ['Montant Mensuel', format_currency(@contract.monthly_amount)],
      ['Fréquence de Facturation', @contract.billing_frequency || '—'],
      ['Mode de Règlement', @contract.billing_method || '—'],
      ['Délai de Paiement', @contract.payment_delay ? "#{@contract.payment_delay} jours" : '—']
    ]
    
    render_info_table(data)
  end
  
  def add_temporality
    section_header('📅 TEMPORALITÉ', COLORS[:primary])
    
    data = [
      ['Date de Signature', format_date(@contract.signature_date)],
      ['Date de Début', format_date(@contract.start_date || @contract.execution_start_date)],
      ['Date de Fin', format_date(@contract.end_date || @contract.execution_end_date)],
      ['Durée Initiale', @contract.initial_duration ? "#{@contract.initial_duration} mois" : '—'],
      ['Reconduction Auto.', @contract.automatic_renewal ? 'Oui' : 'Non'],
      ['Préavis de Résiliation', @contract.termination_notice ? "#{@contract.termination_notice} mois" : '—']
    ]
    
    render_info_table(data)
  end
  
  def add_services_sla
    section_header('🔧 SERVICES ET NIVEAU DE SERVICE', COLORS[:primary])
    
    data = [
      ['Nature des Services', @contract.service_nature || '—'],
      ['Fréquence d\'Intervention', @contract.intervention_frequency || '—'],
      ['Délai d\'Intervention', @contract.intervention_delay ? "#{@contract.intervention_delay}h" : '—'],
      ['Horaires de Travail', @contract.working_hours || '—'],
      ['Astreinte 24/7', @contract.on_call_24_7 ? 'Oui' : 'Non'],
      ['Pièces de Rechange', @contract.spare_parts_included ? 'Incluses' : 'Non incluses']
    ]
    
    render_info_table(data)
  end
  
  def add_footer
    @pdf.number_pages 'Page <page>/<total>', 
      at: [@pdf.bounds.right - 100, 0],
      align: :right,
      size: 8
    
    @pdf.repeat(:all) do
      @pdf.bounding_box([0, 20], width: @pdf.bounds.width) do
        @pdf.font('Helvetica', size: 8) do
          @pdf.fill_color COLORS[:gray]
          @pdf.text "Généré le #{Time.current.strftime('%d/%m/%Y à %H:%M')}", align: :left
          @pdf.fill_color '000000'
        end
      end
    end
  end
  
  # Helper methods
  
  def section_header(title, color = COLORS[:primary])
    @pdf.move_down 5
    @pdf.font('Helvetica-Bold', size: 12) do
      @pdf.fill_color color
      @pdf.text title
      @pdf.fill_color '000000'
    end
    @pdf.stroke_color color
    @pdf.stroke_horizontal_rule
    @pdf.stroke_color '000000'
    @pdf.move_down 10
  end
  
  def render_info_table(data)
    return if data.empty?
    
    @pdf.table(data,
      width: @pdf.bounds.width,
      cell_style: { 
        size: 9, 
        padding: [5, 10],
        borders: [:bottom],
        border_color: COLORS[:light_gray]
      },
      column_widths: { 0 => 150 }
    ) do
      column(0).font_style = :bold
      column(0).text_color = COLORS[:gray]
    end
    
    @pdf.move_down 15
  end
  
  def contact_row(label, value)
    return unless value.present?
    
    @pdf.font('Helvetica', size: 9) do
      @pdf.text "#{label}: #{value}"
    end
  end
  
  def format_currency(amount)
    return '—' unless amount
    number_to_currency(amount, unit: '€', separator: ',', delimiter: ' ', format: '%n %u')
  end
  
  def format_date(date)
    return '—' unless date
    date.strftime('%d/%m/%Y')
  end
  
  def format_status(status)
    return '—' unless status
    
    case status.to_s
    when 'active' then 'Actif'
    when 'expired' then 'Expiré'
    when 'pending' then 'En attente'
    when 'suspended' then 'Suspendu'
    else status.humanize
    end
  end
  
  def has_emergency_info?
    @contract.business_day_breakdown_phone.present? || 
    @contract.on_call_breakdown_phone.present?
  end
end
