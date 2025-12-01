class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.integer :organization_id, null: false
      t.integer :site_id
      t.string :contract_number
      t.string :contract_family
      t.string :status, default: 'active'
      t.decimal :annual_amount, precision: 12, scale: 2
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    
    add_index :contracts, :organization_id
    add_index :contracts, :site_id
    add_index :contracts, :contract_family
    add_index :contracts, :status
    add_index :contracts, :start_date
  end
end
