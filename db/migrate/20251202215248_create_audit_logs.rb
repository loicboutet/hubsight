class CreateAuditLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :audit_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :action, null: false
      t.string :auditable_type, null: false
      t.integer :auditable_id
      t.json :change_data, default: {}
      t.json :metadata, default: {}
      t.string :ip_address
      t.text :user_agent
      t.string :status, default: 'success'
      t.text :error_message

      t.timestamps
    end

    add_index :audit_logs, [:auditable_type, :auditable_id]
    add_index :audit_logs, :action
    add_index :audit_logs, :created_at
    add_index :audit_logs, :status
  end
end
