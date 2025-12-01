class CreateContractFamilies < ActiveRecord::Migration[8.0]
  def change
    create_table :contract_families do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :family_type, null: false # 'family' or 'subfamily'
      t.string :parent_code # References parent family for subfamilies
      t.text :description
      t.string :status, default: 'active', null: false
      t.integer :display_order

      t.timestamps
    end

    add_index :contract_families, :code, unique: true
    add_index :contract_families, :name
    add_index :contract_families, :family_type
    add_index :contract_families, :parent_code
    add_index :contract_families, :status
  end
end
