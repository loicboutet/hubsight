class CreateLevels < ActiveRecord::Migration[8.0]
  def change
    create_table :levels do |t|
      # Core fields from data_models_referential.md specification
      t.string :name, null: false  # Level number/name (Ground floor, Floor 1, Basement 1, etc.)
      t.decimal :altitude, precision: 10, scale: 2  # Altitude relative to ground (m)
      t.decimal :area, precision: 10, scale: 2  # Level floor area (m²)
      
      # Additional field for sorting/organizing
      t.integer :level_number  # Numeric value: 0=ground, positive=floors above, negative=basements
      
      # Associations
      t.references :building, null: false, foreign_key: true
      t.references :organization, foreign_key: true
      
      # Data source tracking (consistent with other models in system)
      t.string :created_by_name
      t.string :updated_by_name
      t.string :import_source
      t.datetime :import_date
      t.string :import_user
      
      t.text :description
      t.timestamps
    end

    add_index :levels, [:building_id, :level_number]
  end
end
