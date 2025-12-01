class CreateAgencies < ActiveRecord::Migration[8.0]
  def change
    create_table :agencies do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :name, null: false
      t.string :code
      t.string :agency_type
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :region
      t.string :phone
      t.string :email
      t.text :service_area
      t.text :certifications
      t.text :specialties
      t.string :manager_name
      t.string :manager_contact
      t.string :operating_hours
      t.string :status, default: 'active', null: false
      t.text :notes

      t.timestamps
    end
    
    add_index :agencies, [:organization_id, :name]
    add_index :agencies, [:organization_id, :code], unique: true
    add_index :agencies, :city
    add_index :agencies, :status
  end
end
