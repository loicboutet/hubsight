class CreateSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :spaces do |t|
      # Core fields from data_models_referential.md specification (23 fields for a SPACE)
      t.string :name, null: false  # Space name/number
      t.string :space_type  # Type: Office, Meeting room, Technical room, etc.
      t.decimal :area, precision: 10, scale: 2  # Area (m²)
      t.decimal :ceiling_height, precision: 10, scale: 2  # Ceiling height (m)
      t.integer :capacity  # Reception capacity (people)
      
      # Usage fields
      t.string :primary_use  # Primary use
      t.string :secondary_use  # Secondary use
      
      # Physical characteristics
      t.string :floor_covering  # Floor covering type
      t.string :wall_covering  # Wall covering type
      t.string :ceiling_type  # Ceiling type
      t.text :present_equipment  # Present equipment
      
      # Technical infrastructure
      t.integer :water_points  # Number of water points
      t.integer :electrical_outlets  # Number of electrical outlets
      t.string :network_connectivity  # Network connectivity type
      t.decimal :natural_lighting, precision: 5, scale: 2  # Natural lighting (%)
      t.string :ventilation  # Ventilation type (natural/mechanical)
      
      # Comfort & Accessibility
      t.boolean :heating  # Heating (yes/no)
      t.boolean :air_conditioning  # Air conditioning (yes/no)
      t.boolean :pmr_accessibility  # PRM (People with Reduced Mobility) accessibility
      t.boolean :has_windows  # Window presence (yes/no)
      
      # Classification
      t.string :omniclass_code  # OmniClass Table 13 classification code
      t.string :grouping_zone  # Zone de regroupement (Administrative, Technical, Commercial, Circulation, Storage)
      
      # Associations
      t.references :level, null: false, foreign_key: true
      t.references :organization, foreign_key: true
      
      # Data source tracking (consistent with other models in system)
      t.string :created_by_name
      t.string :updated_by_name
      t.string :import_source
      t.datetime :import_date
      t.string :import_user
      
      t.text :notes
      t.timestamps
    end

    add_index :spaces, [:level_id, :name]
    add_index :spaces, :space_type
  end
end
