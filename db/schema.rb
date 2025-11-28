# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_28_104841) do
  create_table "active_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "session_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "last_activity_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_activity_at"], name: "index_active_sessions_on_last_activity_at"
    t.index ["session_id"], name: "index_active_sessions_on_session_id", unique: true
    t.index ["user_id"], name: "index_active_sessions_on_user_id"
  end

  create_table "admin_access_logs", force: :cascade do |t|
    t.integer "admin_user_id"
    t.integer "organization_id"
    t.string "action_type"
    t.string "ip_address"
    t.text "user_agent"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_admin_access_logs_on_admin_user_id"
    t.index ["organization_id"], name: "index_admin_access_logs_on_organization_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.text "description"
    t.integer "construction_year"
    t.integer "renovation_year"
    t.decimal "area", precision: 10, scale: 2
    t.integer "number_of_levels"
    t.decimal "height_m", precision: 10, scale: 2
    t.string "structure_type"
    t.string "erp_category"
    t.string "erp_type"
    t.integer "capacity"
    t.boolean "pmr_accessibility"
    t.string "environmental_certification"
    t.decimal "energy_consumption", precision: 10, scale: 2
    t.string "dpe_rating"
    t.string "ghg_rating"
    t.string "status", default: "active", null: false
    t.integer "site_id", null: false
    t.integer "organization_id"
    t.integer "user_id", null: false
    t.string "cadastral_reference"
    t.string "created_by_name"
    t.string "updated_by_name"
    t.string "import_source"
    t.datetime "import_date"
    t.string "import_user"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_buildings_on_organization_id"
    t.index ["site_id", "name"], name: "index_buildings_on_site_id_and_name"
    t.index ["site_id"], name: "index_buildings_on_site_id"
    t.index ["status"], name: "index_buildings_on_status"
    t.index ["user_id"], name: "index_buildings_on_user_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "site_id"
    t.string "contract_number"
    t.string "contract_family"
    t.string "status", default: "active"
    t.decimal "annual_amount", precision: 12, scale: 2
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contract_family"], name: "index_contracts_on_contract_family"
    t.index ["organization_id"], name: "index_contracts_on_organization_id"
    t.index ["site_id"], name: "index_contracts_on_site_id"
    t.index ["start_date"], name: "index_contracts_on_start_date"
    t.index ["status"], name: "index_contracts_on_status"
  end

  create_table "equipment", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "site_id"
    t.string "equipment_type"
    t.string "equipment_category"
    t.date "commissioning_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "space_id"
    t.integer "building_id"
    t.integer "level_id"
    t.string "name"
    t.string "manufacturer"
    t.string "model"
    t.string "serial_number"
    t.string "bdd_reference"
    t.decimal "nominal_power", precision: 10, scale: 2
    t.decimal "nominal_voltage", precision: 10, scale: 2
    t.decimal "current", precision: 10, scale: 2
    t.decimal "frequency", precision: 10, scale: 2
    t.decimal "weight", precision: 10, scale: 2
    t.string "dimensions"
    t.date "manufacturing_date"
    t.date "warranty_end_date"
    t.date "next_maintenance_date"
    t.string "supplier"
    t.decimal "purchase_price", precision: 12, scale: 2
    t.string "order_number"
    t.string "invoice_number"
    t.string "status", default: "active"
    t.string "criticality"
    t.string "created_by_name"
    t.string "updated_by_name"
    t.string "import_source"
    t.datetime "import_date"
    t.string "import_user"
    t.text "notes"
    t.integer "equipment_type_id"
    t.index ["building_id"], name: "index_equipment_on_building_id"
    t.index ["commissioning_date"], name: "index_equipment_on_commissioning_date"
    t.index ["equipment_type"], name: "index_equipment_on_equipment_type"
    t.index ["equipment_type_id"], name: "index_equipment_on_equipment_type_id"
    t.index ["level_id"], name: "index_equipment_on_level_id"
    t.index ["manufacturer"], name: "index_equipment_on_manufacturer"
    t.index ["organization_id"], name: "index_equipment_on_organization_id"
    t.index ["serial_number"], name: "index_equipment_on_serial_number"
    t.index ["site_id"], name: "index_equipment_on_site_id"
    t.index ["space_id"], name: "index_equipment_on_space_id"
    t.index ["status"], name: "index_equipment_on_status"
  end

  create_table "equipment_types", force: :cascade do |t|
    t.string "code", null: false
    t.string "equipment_type_name", null: false
    t.string "equipment_trigram"
    t.string "technical_lot_trigram", null: false
    t.string "technical_lot", null: false
    t.string "purchase_subfamily"
    t.string "function"
    t.string "omniclass_number"
    t.string "omniclass_title"
    t.string "characteristic_1"
    t.string "characteristic_2"
    t.string "characteristic_3"
    t.string "characteristic_4"
    t.string "characteristic_5"
    t.string "characteristic_6"
    t.string "characteristic_7"
    t.string "characteristic_8"
    t.string "characteristic_9"
    t.string "characteristic_10"
    t.string "status", default: "active", null: false
    t.text "description"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_equipment_types_on_code", unique: true
    t.index ["omniclass_number"], name: "index_equipment_types_on_omniclass_number"
    t.index ["purchase_subfamily"], name: "index_equipment_types_on_purchase_subfamily"
    t.index ["status"], name: "index_equipment_types_on_status"
    t.index ["technical_lot"], name: "index_equipment_types_on_technical_lot"
    t.index ["technical_lot_trigram"], name: "index_equipment_types_on_technical_lot_trigram"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "altitude", precision: 10, scale: 2
    t.decimal "area", precision: 10, scale: 2
    t.integer "level_number"
    t.integer "building_id", null: false
    t.integer "organization_id"
    t.string "created_by_name"
    t.string "updated_by_name"
    t.string "import_source"
    t.datetime "import_date"
    t.string "import_user"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id", "level_number"], name: "index_levels_on_building_id_and_level_number"
    t.index ["building_id"], name: "index_levels_on_building_id"
    t.index ["organization_id"], name: "index_levels_on_organization_id"
  end

  create_table "omniclass_spaces", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.text "additional_data_1"
    t.text "additional_data_2"
    t.string "status", default: "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_omniclass_spaces_on_code", unique: true
    t.index ["status"], name: "index_omniclass_spaces_on_status"
    t.index ["title"], name: "index_omniclass_spaces_on_title"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "legal_name"
    t.string "siret"
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
    t.index ["siret"], name: "index_organizations_on_siret"
    t.index ["status"], name: "index_organizations_on_status"
  end

  create_table "site_assignments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "site_id", null: false
    t.datetime "assigned_at"
    t.string "assigned_by_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_site_assignments_on_site_id"
    t.index ["user_id", "site_id"], name: "index_site_assignments_on_user_id_and_site_id", unique: true
    t.index ["user_id"], name: "index_site_assignments_on_user_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.string "site_type", null: false
    t.string "status", default: "active", null: false
    t.text "description"
    t.string "address", null: false
    t.string "city", null: false
    t.string "postal_code", null: false
    t.string "department"
    t.string "region"
    t.string "country", default: "France"
    t.decimal "total_area", precision: 10, scale: 2
    t.decimal "estimated_area", precision: 10, scale: 2
    t.string "site_manager"
    t.string "contact_email"
    t.string "contact_phone"
    t.string "gps_coordinates"
    t.string "climate_zone"
    t.string "cadastral_id"
    t.string "rnb_id"
    t.string "created_by_name"
    t.string "updated_by_name"
    t.string "import_source"
    t.datetime "import_date"
    t.string "import_user"
    t.integer "user_id", null: false
    t.integer "organization_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_sites_on_organization_id"
    t.index ["region"], name: "index_sites_on_region"
    t.index ["site_type"], name: "index_sites_on_site_type"
    t.index ["status"], name: "index_sites_on_status"
    t.index ["user_id", "name"], name: "index_sites_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_sites_on_user_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.string "name", null: false
    t.string "space_type"
    t.decimal "area", precision: 10, scale: 2
    t.decimal "ceiling_height", precision: 10, scale: 2
    t.integer "capacity"
    t.string "primary_use"
    t.string "secondary_use"
    t.string "floor_covering"
    t.string "wall_covering"
    t.string "ceiling_type"
    t.text "present_equipment"
    t.integer "water_points"
    t.integer "electrical_outlets"
    t.string "network_connectivity"
    t.decimal "natural_lighting", precision: 5, scale: 2
    t.string "ventilation"
    t.boolean "heating"
    t.boolean "air_conditioning"
    t.boolean "pmr_accessibility"
    t.boolean "has_windows"
    t.string "omniclass_code"
    t.string "grouping_zone"
    t.integer "level_id", null: false
    t.integer "organization_id"
    t.string "created_by_name"
    t.string "updated_by_name"
    t.string "import_source"
    t.datetime "import_date"
    t.string "import_user"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["level_id", "name"], name: "index_spaces_on_level_id_and_name"
    t.index ["level_id"], name: "index_spaces_on_level_id"
    t.index ["organization_id"], name: "index_spaces_on_organization_id"
    t.index ["space_type"], name: "index_spaces_on_space_type"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.integer "organization_id"
    t.string "status", default: "active"
    t.string "department"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.json "notification_preferences", default: {"email_alerts"=>true, "email_upcoming"=>true, "email_at_risk"=>true, "email_missing_contracts"=>true}
    t.string "language", default: "fr"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_sessions", "users"
  add_foreign_key "buildings", "organizations"
  add_foreign_key "buildings", "sites"
  add_foreign_key "buildings", "users"
  add_foreign_key "equipment", "buildings"
  add_foreign_key "equipment", "equipment_types"
  add_foreign_key "equipment", "levels"
  add_foreign_key "equipment", "spaces"
  add_foreign_key "levels", "buildings"
  add_foreign_key "levels", "organizations"
  add_foreign_key "site_assignments", "sites"
  add_foreign_key "site_assignments", "users"
  add_foreign_key "sites", "users"
  add_foreign_key "spaces", "levels"
  add_foreign_key "spaces", "organizations"
end
