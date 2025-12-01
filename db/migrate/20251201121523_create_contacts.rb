class CreateContacts < ActiveRecord::Migration[8.0]
  def change
    create_table :contacts do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position
      t.string :department
      t.string :phone
      t.string :mobile
      t.string :email
      t.text :availability
      t.string :languages
      t.text :notes
      t.string :status, default: 'active', null: false

      t.timestamps
    end
    
    add_index :contacts, [:organization_id, :email], unique: true
    add_index :contacts, [:organization_id, :last_name]
    add_index :contacts, :status
  end
end
