class AddProfileFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, null: false
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone, :string
    add_column :users, :organization_id, :integer
    add_column :users, :status, :string, default: 'active'
    add_column :users, :department, :string
    
    add_index :users, :role
    add_index :users, :organization_id
    add_index :users, :status
  end
end
