class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :passwordless_sessions, id: :uuid do |t|
      t.belongs_to(
        :authenticatable,
        polymorphic: true,
        index: {name: "authenticatable"},
        type: :uuid
      )
      t.datetime :timeout_at, null: false
      t.datetime :expires_at, null: false
      t.datetime :claimed_at
      t.text :user_agent, null: false
      t.string :remote_addr, null: false
      t.string :token, null: false

      t.timestamps
    end
  end
end# 
