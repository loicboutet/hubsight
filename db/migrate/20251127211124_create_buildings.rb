class CreateBuildings < ActiveRecord::Migration[8.0]
  def change
    create_table :buildings do |t|
      # Core fields
      t.string :name, null: false
      t.string :code
      t.text :description
      
      # Physical characteristics
      t.integer :construction_year
      t.integer :renovation_year
      t.decimal :area, precision: 10, scale: 2  # m²
      t.integer :number_of_levels
      t.decimal :height_m, precision: 10, scale: 2
      t.string :structure_type
      
      # Regulatory (ERP = French regulation for Public Reception Establishments)
      t.string :erp_category
      t.string :erp_type
      t.integer :capacity
      t.boolean :pmr_accessibility  # People with Reduced Mobility
      
      # Energy/Environment
      t.string :environmental_certification
      t.decimal :energy_consumption, precision: 10, scale: 2
      t.string :dpe_rating  # Energy Performance Certificate
      t.string :ghg_rating  # Greenhouse Gas
      
      # Status & Associations
      t.string :status, default: 'active', null: false
      t.references :site, null: false, foreign_key: true
      t.references :organization, foreign_key: true
      t.references :user, null: false, foreign_key: true
      
      # Data source tracking
      t.string :cadastral_reference
      t.string :created_by_name
      t.string :updated_by_name
      t.string :import_source
      t.datetime :import_date
      t.string :import_user
      
      t.text :notes
      t.timestamps
    end

    add_index :buildings, :status
    add_index :buildings, [:site_id, :name]
  end
end
