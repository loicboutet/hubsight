class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :legal_name
      t.string :siret
      t.string :status, default: 'active', null: false

      t.timestamps
    end

    add_index :organizations, :name, unique: true
    add_index :organizations, :siret
    add_index :organizations, :status
  end
end
