class AddFieldsToOrganizations < ActiveRecord::Migration[8.0]
  def change
    add_column :organizations, :organization_type, :string
    add_column :organizations, :headquarters_address, :text
    add_column :organizations, :phone, :string
    add_column :organizations, :email, :string
    add_column :organizations, :website, :string
    add_column :organizations, :specialties, :text
    add_column :organizations, :relationship_start_date, :date
    add_column :organizations, :notes, :text
  end
end
