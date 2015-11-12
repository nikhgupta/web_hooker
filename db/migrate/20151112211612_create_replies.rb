class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.references :destination, index: true, foreign_key: true
      t.references :submission, index: true, foreign_key: true
      t.integer :http_status_code
      t.integer :content_length
      t.string :content_type
      t.text :headers
      t.text :body

      t.timestamps null: false
    end
  end
end
