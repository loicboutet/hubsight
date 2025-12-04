# frozen_string_literal: true

# Service class for exporting equipment list to Excel
# Includes full hierarchy context (Site > Building > Level > Space)
class EquipmentListExporter
  def initialize(organization, filter_params = {}, current_user = nil)
    @organization = organization
    @filter_params = filter_params
    @current_user = current_user
  end

  def generate
    package = Axlsx::Package.new
    workbook = package.workbook

    generate_equipment_sheet(workbook)

    package.to_stream.read
  end

  private

  def generate_equipment_sheet(workbook)
    # Create header style
    @header_style = workbook.styles.add_style(
      bg_color: '4F46E5',
      fg_color: 'FFFFFF',
      b: true,
      sz: 11,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    )

    workbook.add_worksheet(name: 'Liste des Équipements') do |sheet|
      add_header(sheet)
      add_equipment_data(sheet)
      apply_formatting(sheet)
    end
  end

  def add_header(sheet)
    sheet.add_row [
      'Site',
      'Bâtiment',
      'Niveau',
      'Espace',
      'Nom Équipement',
      'Type',
      'Catégorie',
      'Fabricant',
      'Modèle',
      'Numéro de Série',
      'Référence BDD',
      'Puissance Nominale',
      'Tension Nominale',
      'Courant',
      'Fréquence',
      'Poids (kg)',
      'Dimensions',
      'Date Fabrication',
      'Date Mise en Service',
      'Date Fin Garantie',
      'Prochaine Maintenance',
      'Fournisseur',
      'Prix d\'Achat',
      'Numéro Commande',
      'Numéro Facture',
      'Statut',
      'Criticité',
      'Notes'
    ], style: @header_style
  end

  def add_equipment_data(sheet)
    equipment_list.each do |equipment|
      sheet.add_row [
        equipment.site&.name || '-',
        equipment.building&.name || '-',
        equipment.level&.name || '-',
        equipment.space&.name || '-',
        equipment.name,
        equipment.equipment_type&.equipment_type_name || '-',
        equipment.equipment_category || '-',
        equipment.manufacturer || '-',
        equipment.model || '-',
        equipment.serial_number || '-',
        equipment.bdd_reference || '-',
        equipment.nominal_power || '-',
        equipment.nominal_voltage || '-',
        equipment.current || '-',
        equipment.frequency || '-',
        format_number(equipment.weight),
        equipment.dimensions || '-',
        format_date(equipment.manufacturing_date),
        format_date(equipment.commissioning_date),
        format_date(equipment.warranty_end_date),
        format_date(equipment.next_maintenance_date),
        equipment.supplier || '-',
        format_currency(equipment.purchase_price),
        equipment.order_number || '-',
        equipment.invoice_number || '-',
        equipment.status_label,
        equipment.criticality_label || '-',
        equipment.notes || '-'
      ]
    end
  end

  def apply_formatting(sheet)
    # Freeze header row
    sheet.sheet_view.pane do |pane|
      pane.top_left_cell = 'A2'
      pane.state = :frozen
      pane.y_split = 1
    end

    # Set column widths
    sheet.column_widths(
      20,  # Site
      20,  # Bâtiment
      20,  # Niveau
      25,  # Espace
      30,  # Nom Équipement
      20,  # Type
      15,  # Catégorie
      20,  # Fabricant
      20,  # Modèle
      20,  # Numéro de Série
      15,  # Référence BDD
      18,  # Puissance Nominale
      18,  # Tension Nominale
      12,  # Courant
      12,  # Fréquence
      12,  # Poids
      20,  # Dimensions
      15,  # Date Fabrication
      15,  # Date Mise en Service
      15,  # Date Fin Garantie
      15,  # Prochaine Maintenance
      20,  # Fournisseur
      15,  # Prix d'Achat
      15,  # Numéro Commande
      15,  # Numéro Facture
      15,  # Statut
      12,  # Criticité
      30   # Notes
    )
  end

  # =============================================================================
  # HELPER METHODS
  # =============================================================================

  def equipment_list
    @equipment_list ||= begin
      # Get base query
      equipment = if @organization
                    @organization.equipment
                  else
                    # For admin users without organization, export all equipment
                    Equipment.all
                  end
      
      # Apply filters
      equipment = apply_filters(equipment)
      
      # Apply includes and ordering
      equipment.includes(:equipment_type, space: { level: { building: :site } })
               .order('sites.name, buildings.name, levels.level_number, spaces.name, equipment.name')
    end
  end

  def apply_filters(equipment)
    # Search filter (name, serial number, manufacturer, model)
    if @filter_params[:search].present?
      search_term = "%#{@filter_params[:search]}%"
      equipment = equipment.where(
        "name LIKE ? OR serial_number LIKE ? OR manufacturer LIKE ? OR model LIKE ?",
        search_term, search_term, search_term, search_term
      )
    end
    
    # Organization filter (admin only)
    if @filter_params[:organization].present? && @current_user&.admin?
      equipment = equipment.where(organization_id: @filter_params[:organization])
    end
    
    # Site filter
    if @filter_params[:site].present?
      equipment = equipment.where(site_id: @filter_params[:site])
    end
    
    # Building filter
    if @filter_params[:building].present?
      equipment = equipment.where(building_id: @filter_params[:building])
    end
    
    # Equipment type filter
    if @filter_params[:equipment_type].present?
      equipment = equipment.where(equipment_type_id: @filter_params[:equipment_type])
    end
    
    # Status filter
    if @filter_params[:status].present?
      equipment = equipment.where(status: @filter_params[:status])
    end
    
    # Criticality filter
    if @filter_params[:criticality].present?
      equipment = equipment.where(criticality: @filter_params[:criticality])
    end
    
    equipment
  end

  def format_number(value)
    return '-' if value.nil?
    value.to_f.round(2)
  end

  def format_date(date)
    return '-' if date.nil?
    date.strftime('%d/%m/%Y')
  end

  def format_currency(value)
    return '-' if value.nil?
    "#{value.to_f.round(2)} €"
  end
end
