class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :destination, index: true, foreign_key: true
      t.references :submission, index: true, foreign_key: true

      t.string :content_type

      t.integer :http_status_code
      t.integer :response_time, default: 0
      t.integer :content_length, default: 0

      t.text :headers
      t.text :body

      t.timestamps null: false
    end
  end
end
