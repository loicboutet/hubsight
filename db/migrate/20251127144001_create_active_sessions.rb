class CreateActiveSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :active_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :session_id, null: false
      t.string :ip_address
      t.string :user_agent
      t.datetime :last_activity_at

      t.timestamps
    end
    
    add_index :active_sessions, :session_id, unique: true
    add_index :active_sessions, :last_activity_at
  end
end
