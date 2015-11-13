class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.references :portal, index: true, foreign_key: true
      t.string :url

      t.timestamps null: false
    end
  end
end
