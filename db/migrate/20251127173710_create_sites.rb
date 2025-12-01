class CreateSites < ActiveRecord::Migration[8.0]
  def change
    create_table :sites do |t|
      # Basic information
      t.string :name, null: false
      t.string :code
      t.string :site_type, null: false
      t.string :status, default: "active", null: false
      t.text :description
      
      # Location information
      t.string :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.string :department
      t.string :region
      t.string :country, default: "France"
      
      # Area metrics
      t.decimal :total_area, precision: 10, scale: 2
      t.decimal :estimated_area, precision: 10, scale: 2
      
      # Contact information
      t.string :site_manager
      t.string :contact_email
      t.string :contact_phone
      
      # Technical information
      t.string :gps_coordinates
      t.string :climate_zone
      t.string :cadastral_id
      t.string :rnb_id
      
      # Data source tracking
      t.string :created_by_name
      t.string :updated_by_name
      t.string :import_source
      t.datetime :import_date
      t.string :import_user
      
      # Multi-tenancy and associations
      t.references :user, null: false, foreign_key: true
      t.integer :organization_id
      
      t.timestamps
    end
    
    add_index :sites, :site_type
    add_index :sites, :status
    add_index :sites, :region
    add_index :sites, :organization_id
    add_index :sites, [:user_id, :name], unique: true
  end
end
