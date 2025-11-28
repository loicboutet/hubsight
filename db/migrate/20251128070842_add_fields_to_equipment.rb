class AddFieldsToEquipment < ActiveRecord::Migration[8.0]
  def change
    # Critical: Add space_id foreign key (equipment nested under spaces)
    add_column :equipment, :space_id, :integer
    add_column :equipment, :building_id, :integer
    add_column :equipment, :level_id, :integer
    
    # Base Equipment Information
    add_column :equipment, :name, :string
    add_column :equipment, :manufacturer, :string
    add_column :equipment, :model, :string
    add_column :equipment, :serial_number, :string
    add_column :equipment, :bdd_reference, :string
    
    # Technical Specifications
    add_column :equipment, :nominal_power, :decimal, precision: 10, scale: 2
    add_column :equipment, :nominal_voltage, :decimal, precision: 10, scale: 2
    add_column :equipment, :current, :decimal, precision: 10, scale: 2
    add_column :equipment, :frequency, :decimal, precision: 10, scale: 2
    add_column :equipment, :weight, :decimal, precision: 10, scale: 2
    add_column :equipment, :dimensions, :string
    
    # Dates
    add_column :equipment, :manufacturing_date, :date
    add_column :equipment, :warranty_end_date, :date
    add_column :equipment, :next_maintenance_date, :date
    
    # Supplier Information
    add_column :equipment, :supplier, :string
    add_column :equipment, :purchase_price, :decimal, precision: 12, scale: 2
    add_column :equipment, :order_number, :string
    add_column :equipment, :invoice_number, :string
    
    # Status and Classification
    add_column :equipment, :status, :string, default: 'active'
    add_column :equipment, :criticality, :string
    
    # Data Source Tracking (following pattern from spaces/levels/buildings)
    add_column :equipment, :created_by_name, :string
    add_column :equipment, :updated_by_name, :string
    add_column :equipment, :import_source, :string
    add_column :equipment, :import_date, :datetime
    add_column :equipment, :import_user, :string
    
    # Additional Information
    add_column :equipment, :notes, :text
    
    # Add indexes for performance
    add_index :equipment, :space_id
    add_index :equipment, :building_id
    add_index :equipment, :level_id
    add_index :equipment, :status
    add_index :equipment, :manufacturer
    add_index :equipment, :serial_number
    
    # Add foreign key constraints
    add_foreign_key :equipment, :spaces
    add_foreign_key :equipment, :buildings
    add_foreign_key :equipment, :levels
  end
end
