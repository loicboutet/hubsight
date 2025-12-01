class AddEquipmentTypeToEquipment < ActiveRecord::Migration[8.0]
  def change
    add_reference :equipment, :equipment_type, null: true, foreign_key: true
  end
end
