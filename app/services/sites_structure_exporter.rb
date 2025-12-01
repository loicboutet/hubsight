# frozen_string_literal: true

# Service class for exporting sites hierarchical structure to Excel
# Supports two formats:
# 1. Hierarchical indentation (single sheet with visual hierarchy)
# 2. Nested sheets (separate sheets for Sites, Buildings, Levels, Spaces, Equipment)
class SitesStructureExporter
  def initialize(organization, format = 'hierarchical')
    @organization = organization
    @format = format
  end

  def generate
    package = Axlsx::Package.new
    workbook = package.workbook

    case @format
    when 'sheets', 'nested'
      generate_nested_sheets(workbook)
    else
      generate_hierarchical_sheet(workbook)
    end

    package.to_stream.read
  end

  private

  # =============================================================================
  # HIERARCHICAL INDENTATION FORMAT (Single Sheet)
  # =============================================================================

  def generate_hierarchical_sheet(workbook)
    workbook.add_worksheet(name: 'Structure Hiérarchique') do |sheet|
      add_hierarchical_header(sheet)
      add_hierarchical_data(sheet)
      apply_hierarchical_formatting(sheet)
    end
  end

  def add_hierarchical_header(sheet)
    sheet.add_row [
      'Niveau',
      'Type',
      'Code',
      'Nom',
      'Type/Catégorie',
      'Surface (m²)',
      'Localisation',
      'Année/Date',
      'Statut',
      'Détails'
    ], style: header_style
  end

  def add_hierarchical_data(sheet)
    sites.each do |site|
      add_site_row(sheet, site)
      
      site.buildings.order(:name).each do |building|
        add_building_row(sheet, building)
        
        building.levels.order(:level_number).each do |level|
          add_level_row(sheet, level)
          
          level.spaces.order(:name).each do |space|
            add_space_row(sheet, space)
            
            space.equipment.order(:name).each do |equipment|
              add_equipment_row(sheet, equipment)
            end
          end
        end
      end
    end
  end

  def add_site_row(sheet, site)
    sheet.add_row [
      0, # Indent level
      '🏢 Site',
      site.code,
      site.name,
      site.site_type,
      format_number(site.total_area),
      "#{site.address}, #{site.city}",
      nil,
      site.status,
      "#{site.region} - #{site.department}"
    ]
  end

  def add_building_row(sheet, building)
    sheet.add_row [
      1, # Indent level
      '  🏗️ Bâtiment',
      building.code,
      building.name,
      building.structure_type,
      format_number(building.area),
      building.site.name,
      building.construction_year,
      building.status,
      "#{building.number_of_levels} niveaux"
    ]
  end

  def add_level_row(sheet, level)
    sheet.add_row [
      2, # Indent level
      '    📊 Niveau',
      level.level_number,
      level.name,
      nil,
      format_number(level.area),
      "#{level.building.name}",
      nil,
      nil,
      "Altitude: #{format_number(level.altitude)}m"
    ]
  end

  def add_space_row(sheet, space)
    sheet.add_row [
      3, # Indent level
      '      🏠 Espace',
      nil,
      space.name,
      space.space_type,
      format_number(space.area),
      "#{space.level.name}",
      nil,
      nil,
      "Capacité: #{space.capacity || '-'}"
    ]
  end

  def add_equipment_row(sheet, equipment)
    sheet.add_row [
      4, # Indent level
      '        ⚙️ Équipement',
      equipment.serial_number,
      equipment.name,
      equipment.equipment_type,
      nil,
      "#{equipment.space.name}",
      format_date(equipment.commissioning_date),
      equipment.status,
      "#{equipment.manufacturer} #{equipment.model}".strip
    ]
  end

  def apply_hierarchical_formatting(sheet)
    # Freeze header row
    sheet.sheet_view.pane do |pane|
      pane.top_left_cell = 'A2'
      pane.state = :frozen
      pane.y_split = 1
    end

    # Auto-fit columns
    sheet.column_widths 10, 20, 15, 30, 20, 15, 30, 15, 12, 30
  end

  # =============================================================================
  # NESTED SHEETS FORMAT (Multiple Sheets)
  # =============================================================================

  def generate_nested_sheets(workbook)
    add_sites_sheet(workbook)
    add_buildings_sheet(workbook)
    add_levels_sheet(workbook)
    add_spaces_sheet(workbook)
    add_equipment_sheet(workbook)
  end

  def add_sites_sheet(workbook)
    workbook.add_worksheet(name: 'Sites') do |sheet|
      sheet.add_row [
        'Code',
        'Nom',
        'Type',
        'Adresse',
        'Ville',
        'Code Postal',
        'Région',
        'Département',
        'Surface Totale (m²)',
        'Nombre de Bâtiments',
        'Contact',
        'Téléphone',
        'Statut'
      ], style: header_style

      sites.each do |site|
        sheet.add_row [
          site.code,
          site.name,
          site.site_type,
          site.address,
          site.city,
          site.postal_code,
          site.region,
          site.department,
          format_number(site.total_area),
          site.buildings.count,
          site.contact_email,
          site.contact_phone,
          site.status
        ]
      end

      sheet.column_widths 12, 25, 15, 35, 20, 12, 20, 15, 15, 15, 25, 15, 12
    end
  end

  def add_buildings_sheet(workbook)
    workbook.add_worksheet(name: 'Bâtiments') do |sheet|
      sheet.add_row [
        'Site',
        'Code Bâtiment',
        'Nom',
        'Référence Cadastrale',
        'Année Construction',
        'Année Rénovation',
        'Surface (m²)',
        'Nombre de Niveaux',
        'Hauteur (m)',
        'Type Structure',
        'Catégorie ERP',
        'Capacité',
        'Statut'
      ], style: header_style

      sites.each do |site|
        site.buildings.order(:name).each do |building|
          sheet.add_row [
            site.name,
            building.code,
            building.name,
            building.cadastral_reference,
            building.construction_year,
            building.renovation_year,
            format_number(building.area),
            building.number_of_levels,
            format_number(building.height_m),
            building.structure_type,
            building.erp_category,
            building.capacity,
            building.status
          ]
        end
      end

      sheet.column_widths 25, 15, 25, 20, 15, 15, 15, 15, 12, 15, 12, 12, 12
    end
  end

  def add_levels_sheet(workbook)
    workbook.add_worksheet(name: 'Niveaux') do |sheet|
      sheet.add_row [
        'Site',
        'Bâtiment',
        'Nom Niveau',
        'Numéro Niveau',
        'Altitude (m)',
        'Surface (m²)',
        'Nombre d\'Espaces',
        'Description'
      ], style: header_style

      sites.each do |site|
        site.buildings.order(:name).each do |building|
          building.levels.order(:level_number).each do |level|
            sheet.add_row [
              site.name,
              building.name,
              level.name,
              level.level_number,
              format_number(level.altitude),
              format_number(level.area),
              level.spaces.count,
              level.description
            ]
          end
        end
      end

      sheet.column_widths 25, 25, 25, 15, 15, 15, 15, 40
    end
  end

  def add_spaces_sheet(workbook)
    workbook.add_worksheet(name: 'Espaces') do |sheet|
      sheet.add_row [
        'Site',
        'Bâtiment',
        'Niveau',
        'Nom Espace',
        'Type',
        'Surface (m²)',
        'Hauteur Plafond (m)',
        'Capacité',
        'Usage Principal',
        'Zone Groupement',
        'Code OmniClass',
        'Nombre d\'Équipements'
      ], style: header_style

      sites.each do |site|
        site.buildings.order(:name).each do |building|
          building.levels.order(:level_number).each do |level|
            level.spaces.order(:name).each do |space|
              sheet.add_row [
                site.name,
                building.name,
                level.name,
                space.name,
                space.space_type,
                format_number(space.area),
                format_number(space.ceiling_height),
                space.capacity,
                space.primary_use,
                space.grouping_zone,
                space.omniclass_code,
                space.equipment.count
              ]
            end
          end
        end
      end

      sheet.column_widths 25, 25, 20, 25, 15, 12, 12, 10, 20, 15, 15, 15
    end
  end

  def add_equipment_sheet(workbook)
    workbook.add_worksheet(name: 'Équipements') do |sheet|
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
        'Date Mise en Service',
        'Puissance Nominale',
        'Statut',
        'Criticité'
      ], style: header_style

      sites.each do |site|
        site.buildings.order(:name).each do |building|
          building.levels.order(:level_number).each do |level|
            level.spaces.order(:name).each do |space|
              space.equipment.order(:name).each do |equipment|
                sheet.add_row [
                  site.name,
                  building.name,
                  level.name,
                  space.name,
                  equipment.name,
                  equipment.equipment_type,
                  equipment.equipment_category,
                  equipment.manufacturer,
                  equipment.model,
                  equipment.serial_number,
                  format_date(equipment.commissioning_date),
                  equipment.nominal_power,
                  equipment.status,
                  equipment.criticality
                ]
              end
            end
          end
        end
      end

      sheet.column_widths 25, 25, 20, 25, 30, 20, 15, 20, 20, 20, 15, 15, 12, 12
    end
  end

  # =============================================================================
  # HELPER METHODS
  # =============================================================================

  def sites
    @sites ||= @organization.sites
                            .includes(buildings: { levels: { spaces: :equipment } })
                            .order(:name)
  end

  def header_style
    {
      bg_color: '4F46E5',
      fg_color: 'FFFFFF',
      b: true,
      sz: 11,
      alignment: { horizontal: :center, vertical: :center, wrap_text: true }
    }
  end

  def format_number(value)
    return nil if value.nil?
    value.to_f.round(2)
  end

  def format_date(date)
    return nil if date.nil?
    date.strftime('%d/%m/%Y')
  end
end
