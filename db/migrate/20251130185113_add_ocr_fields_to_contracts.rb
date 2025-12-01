class AddOcrFieldsToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :ocr_text, :text
    add_column :contracts, :ocr_status, :string, default: 'pending'
    add_column :contracts, :ocr_processed_at, :datetime
    add_column :contracts, :ocr_error_message, :text
    add_column :contracts, :ocr_provider, :string
    add_column :contracts, :ocr_page_count, :integer
    
    # Add indexes for efficient querying
    add_index :contracts, :ocr_status
    add_index :contracts, :ocr_provider
    add_index :contracts, :ocr_processed_at
  end
end
