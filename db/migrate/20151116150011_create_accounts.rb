class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :subdomain

      t.integer :users_count, default: 0
      t.integer :portals_count, default: 0
      t.integer :destinations_count, default: 0
      t.integer :submissions_count, default: 0
      t.integer :replies_count, default: 0

      t.timestamps null: false
    end
  end
end
