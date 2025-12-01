class CreateAdminAccessLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_access_logs do |t|
      t.integer :admin_user_id
      t.integer :organization_id
      t.string :action_type
      t.string :ip_address
      t.text :user_agent
      t.datetime :started_at
      t.datetime :ended_at
      t.json :metadata

      t.timestamps
    end
    add_index :admin_access_logs, :admin_user_id
    add_index :admin_access_logs, :organization_id
  end
end
