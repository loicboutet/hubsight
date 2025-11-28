class CreateOmniklassSpaces < ActiveRecord::Migration[8.0]
  def change
    create_table :omniclass_spaces do |t|
      # OmniClass Table 13 classification code (primary classification field)
      t.string :code, null: false
      
      # Classification title/description
      t.string :title, null: false
      
      # Additional data fields from Excel (unnamed columns in documentation)
      t.text :additional_data_1
      t.text :additional_data_2
      
      # Status for future management
      t.string :status, default: 'active'
      
      t.timestamps
    end
    
    # Code should be unique as it's the primary identifier for lookups
    add_index :omniclass_spaces, :code, unique: true
    add_index :omniclass_spaces, :status
    add_index :omniclass_spaces, :title
  end
end
