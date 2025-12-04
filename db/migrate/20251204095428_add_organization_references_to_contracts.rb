class AddOrganizationReferencesToContracts < ActiveRecord::Migration[8.0]
  def change
    # Add foreign keys for contractor and client organizations
    # Optional (nullable) to maintain backward compatibility with existing contracts
    # and to allow LLM extraction flow where organizations are linked later
    add_reference :contracts, :contractor_organization, foreign_key: { to_table: :organizations }, index: true
    add_reference :contracts, :client_organization, foreign_key: { to_table: :organizations }, index: true
    
    # Note: We keep the existing text fields contractor_organization_name and client_organization_name
    # for backward compatibility and as fallback display values
  end
end
