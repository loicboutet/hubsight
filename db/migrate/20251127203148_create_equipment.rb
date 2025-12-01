class CreateEquipment < ActiveRecord::Migration[8.0]
  def change
    create_table :equipment do |t|
      t.integer :organization_id, null: false
      t.integer :site_id
      t.string :equipment_type
      t.string :equipment_category
      t.date :commissioning_date

      t.timestamps
    end
    
    add_index :equipment, :organization_id
    add_index :equipment, :site_id
    add_index :equipment, :equipment_type
    add_index :equipment, :commissioning_date
  end
end
