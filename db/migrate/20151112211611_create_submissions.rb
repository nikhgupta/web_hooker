class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :portal, index: true, foreign_key: true

      t.string :host
      t.string :ip
      t.string :uuid
      t.string :request_method
      t.string :content_type

      t.integer :content_length, default: 0
      t.integer :failed_replies_count, default: 0
      t.integer :successful_replies_count, default: 0

      t.text :headers
      t.text :body

      t.timestamps null: false
    end
  end
end
