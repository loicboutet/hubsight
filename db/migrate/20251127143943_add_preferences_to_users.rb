class AddPreferencesToUsers < ActiveRecord::Migration[8.0]
  def change
    # Notification preferences as JSON column
    add_column :users, :notification_preferences, :json, default: {
      email_alerts: true,
      email_upcoming: true,
      email_at_risk: true,
      email_missing_contracts: true
    }
    
    # Language settings
    add_column :users, :language, :string, default: 'fr'
  end
end
