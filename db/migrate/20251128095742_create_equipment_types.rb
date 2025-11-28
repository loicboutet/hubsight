class CreateEquipmentTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment_types do |t|
      # Core identification
      t.string :code, null: false
      t.string :equipment_type_name, null: false
      t.string :equipment_trigram
      
      # Technical lot classification
      t.string :technical_lot_trigram, null: false  # CEA, CVC, ELE, PLO, SEC, ASC, CTE, etc.
      t.string :technical_lot, null: false           # Full name: HVAC, Electrical, etc.
      
      # Purchase classification
      t.string :purchase_subfamily                   # EXTERIOR JOINERY, ELEVATORS, HVAC, etc.
      
      # Function and type
      t.string :function                             # Equipment function
      
      # OmniClass classification (BIM standard)
      t.string :omniclass_number                     # International BIM classification code
      t.string :omniclass_title                      # OmniClass label
      
      # Technical characteristics (10 customizable fields)
      t.string :characteristic_1
      t.string :characteristic_2
      t.string :characteristic_3
      t.string :characteristic_4
      t.string :characteristic_5
      t.string :characteristic_6
      t.string :characteristic_7
      t.string :characteristic_8
      t.string :characteristic_9
      t.string :characteristic_10
      
      # Metadata
      t.string :status, default: 'active', null: false
      t.text :description
      t.text :notes

      t.timestamps
    end

    # Indexes for performance
    add_index :equipment_types, :code, unique: true
    add_index :equipment_types, :technical_lot_trigram
    add_index :equipment_types, :technical_lot
    add_index :equipment_types, :purchase_subfamily
    add_index :equipment_types, :omniclass_number
    add_index :equipment_types, :status
  end
end
