class AddValidationFieldsToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :validation_status, :string, default: 'pending'
    add_column :contracts, :validated_at, :datetime
    add_column :contracts, :validated_by, :string
    add_column :contracts, :validation_notes, :text
    add_column :contracts, :corrected_fields, :json, default: {}
    
    add_index :contracts, :validation_status
    add_index :contracts, :validated_at
  end
end
