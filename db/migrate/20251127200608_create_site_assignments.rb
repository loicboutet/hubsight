class CreateSiteAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :site_assignments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :site, null: false, foreign_key: true
      t.datetime :assigned_at
      t.string :assigned_by_name

      t.timestamps
    end

    add_index :site_assignments, [:user_id, :site_id], unique: true
  end
end
