class AddLlmFieldsToContracts < ActiveRecord::Migration[8.0]
  def change
    # ========================================
    # CATEGORY 1: IDENTIFICATION (10 fields)
    # ========================================
    add_column :contracts, :title, :string
    add_column :contracts, :contract_type, :string
    add_column :contracts, :purchase_subfamily, :string
    add_column :contracts, :contract_object, :text
    add_column :contracts, :detailed_description, :text
    add_column :contracts, :contracting_method, :string
    add_column :contracts, :public_reference, :string
    
    # ========================================
    # CATEGORY 2: STAKEHOLDERS (10 fields)
    # ========================================
    add_column :contracts, :contractor_organization_name, :string
    add_column :contracts, :contractor_contact_name, :string
    add_column :contracts, :contractor_agency_name, :string
    add_column :contracts, :client_organization_name, :string
    add_column :contracts, :client_contact_name, :string
    add_column :contracts, :managing_department, :string
    add_column :contracts, :monitoring_manager, :string
    add_column :contracts, :contractor_phone, :string
    add_column :contracts, :contractor_email, :string
    add_column :contracts, :client_contact_email, :string
    
    # ========================================
    # CATEGORY 3: SCOPE (15 fields)
    # ========================================
    add_column :contracts, :covered_sites, :jsonb, default: []
    add_column :contracts, :covered_buildings, :jsonb, default: []
    add_column :contracts, :covered_equipment_types, :jsonb, default: []
    add_column :contracts, :covered_equipment_list, :text
    add_column :contracts, :equipment_count, :integer
    add_column :contracts, :geographic_areas, :string
    add_column :contracts, :building_names, :text
    add_column :contracts, :floor_levels, :string
    add_column :contracts, :specific_zones, :text
    add_column :contracts, :technical_lot, :string
    add_column :contracts, :equipment_categories, :string
    add_column :contracts, :coverage_description, :text
    add_column :contracts, :exclusions, :text
    add_column :contracts, :special_conditions, :text
    add_column :contracts, :scope_notes, :text
    
    # ========================================
    # CATEGORY 4: FINANCIAL (15 fields)
    # ========================================
    add_column :contracts, :annual_amount_ht, :decimal, precision: 12, scale: 2
    add_column :contracts, :annual_amount_ttc, :decimal, precision: 12, scale: 2
    add_column :contracts, :monthly_amount, :decimal, precision: 12, scale: 2
    add_column :contracts, :billing_method, :string
    add_column :contracts, :billing_frequency, :string
    add_column :contracts, :payment_terms, :string
    add_column :contracts, :revision_conditions, :text
    add_column :contracts, :revision_index, :string
    add_column :contracts, :revision_frequency, :string
    add_column :contracts, :late_payment_penalties, :text
    add_column :contracts, :financial_guarantee, :string
    add_column :contracts, :deposit_amount, :decimal, precision: 12, scale: 2
    add_column :contracts, :price_revision_date, :date
    add_column :contracts, :last_amount_update, :date
    add_column :contracts, :budget_code, :string
    
    # ========================================
    # CATEGORY 5: TEMPORALITY (10 fields)
    # ========================================
    add_column :contracts, :signature_date, :date
    add_column :contracts, :execution_start_date, :date
    add_column :contracts, :initial_duration_months, :integer
    add_column :contracts, :renewal_duration_months, :integer
    add_column :contracts, :renewal_count, :integer
    add_column :contracts, :automatic_renewal, :boolean, default: false
    add_column :contracts, :notice_period_days, :integer
    add_column :contracts, :next_deadline_date, :date
    add_column :contracts, :last_renewal_date, :date
    add_column :contracts, :termination_date, :date
    
    # ========================================
    # CATEGORY 6: SERVICES & SLA (12 fields)
    # ========================================
    add_column :contracts, :service_nature, :text
    add_column :contracts, :intervention_frequency, :string
    add_column :contracts, :intervention_delay_hours, :integer
    add_column :contracts, :resolution_delay_hours, :integer
    add_column :contracts, :working_hours, :string
    add_column :contracts, :on_call_24_7, :boolean, default: false
    add_column :contracts, :sla_percentage, :decimal, precision: 5, scale: 2
    add_column :contracts, :kpis, :jsonb, default: []
    add_column :contracts, :spare_parts_included, :boolean
    add_column :contracts, :supplies_included, :boolean
    add_column :contracts, :report_required, :boolean
    add_column :contracts, :appendix_documents, :jsonb, default: []
    
    # ========================================
    # LLM EXTRACTION TRACKING (7 fields)
    # ========================================
    add_column :contracts, :extraction_status, :string
    add_column :contracts, :extraction_data, :jsonb
    add_column :contracts, :extraction_provider, :string
    add_column :contracts, :extraction_model, :string
    add_column :contracts, :extraction_confidence, :decimal, precision: 5, scale: 2
    add_column :contracts, :extraction_processed_at, :datetime
    add_column :contracts, :extraction_notes, :text
    
    # ========================================
    # INDEXES for performance
    # ========================================
    add_index :contracts, :extraction_status
    add_index :contracts, :extraction_processed_at
    add_index :contracts, :title
    add_index :contracts, :contract_type
    add_index :contracts, :contractor_organization_name
    add_index :contracts, :signature_date
    add_index :contracts, :execution_start_date
    add_index :contracts, :next_deadline_date
  end
end
