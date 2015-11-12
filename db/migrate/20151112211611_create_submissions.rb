class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.references :portal, index: true, foreign_key: true
      t.string :host
      t.string :ip
      t.string :uuid
      t.string :request_method
      t.string :content_type
      t.integer :content_length
      t.text :headers
      t.text :body
      t.integer :failed_replies_count, default: 0
      t.integer :successful_replies_count, default: 0

      t.timestamps null: false
    end
  end
end
