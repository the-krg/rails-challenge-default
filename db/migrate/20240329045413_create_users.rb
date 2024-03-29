class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email,           null: false
      t.string :phone_number,    null: false
      t.string :full_name
      t.string :password_digest, null: false
      t.string :key,             null: false
      t.string :account_key
      t.string :metadata

      t.timestamps
    end

    # Ensuring uniqueness on the database side to avoid race conditions.
    add_index :users, :email, unique: true
    add_index :users, :phone_number, unique: true
    add_index :users, :key, unique: true
    add_index :users, :account_key, unique: true

    # Length validation placed on models because rules could change over time.
  end
end
