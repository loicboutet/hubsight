class CreatePriceReferences < ActiveRecord::Migration[8.0]
  def change
    create_table :price_references do |t|
      t.string :contract_family, null: false
      t.string :contract_sub_family
      t.string :equipment_type
      t.string :service_type
      t.text :technical_characteristics
      t.decimal :reference_price, precision: 12, scale: 2
      t.string :unit
      t.string :currency, default: 'EUR'
      t.string :location
      t.string :city
      t.text :notes
      t.string :status, default: 'active', null: false

      t.timestamps
    end
    
    add_index :price_references, :contract_family
    add_index :price_references, :equipment_type
    add_index :price_references, :location
    add_index :price_references, :status
  end
end
