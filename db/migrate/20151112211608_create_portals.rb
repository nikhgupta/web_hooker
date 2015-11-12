class CreatePortals < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.references :user, index: true, foreign_key: true

      t.string :title
      t.string :slug

      t.integer :submissions_count, default: 0
      t.integer :destinations_count, default: 0

      t.timestamps null: false
    end

    add_index :portals, :slug, unique: true
  end
end
