class CreateUserPreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :user_preferences, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, unique: true, type: :uuid
      t.jsonb :data

      t.timestamps
    end
  end
end
