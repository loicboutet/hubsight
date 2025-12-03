class AddTypeSpecificFieldsToContracts < ActiveRecord::Migration[8.0]
  def change
    # Property Deed specific fields
    add_column :contracts, :property_deed_site, :string
    add_column :contracts, :property_deed_acquisition_date, :date
    add_column :contracts, :property_deed_area, :decimal, precision: 10, scale: 2
    add_column :contracts, :property_deed_usage_type, :string
    add_column :contracts, :property_deed_type, :string
    add_column :contracts, :property_deed_acquisition_price, :decimal, precision: 12, scale: 2
    add_column :contracts, :property_deed_current_value, :decimal, precision: 12, scale: 2
    add_column :contracts, :property_deed_value_update_date, :date
    add_column :contracts, :property_deed_alerts, :text
    
    # Lease specific fields
    add_column :contracts, :lease_type, :string
    add_column :contracts, :lease_area, :decimal, precision: 10, scale: 2
    add_column :contracts, :monthly_rent_excl_tax, :decimal, precision: 12, scale: 2
    add_column :contracts, :monthly_charges, :decimal, precision: 12, scale: 2
    add_column :contracts, :indexation_type, :string
    add_column :contracts, :indexation_rate, :decimal, precision: 5, scale: 2
    add_column :contracts, :lease_effective_date, :date
    add_column :contracts, :lease_duration_months, :integer
    add_column :contracts, :next_lease_deadline, :date
    add_column :contracts, :lease_alerts, :text
  end
end
