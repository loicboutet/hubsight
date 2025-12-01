class AddVatRateToContracts < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :vat_rate, :decimal, precision: 5, scale: 2, default: 20.0
    add_index :contracts, :vat_rate
  end
end
