class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title, null: false, limit: 150, unique: true
      t.date :date, null: false
      t.time :start_time, null: false
      t.string :short_desc, limit: 200
      t.text :desc, null: false
      t.string :city, null: false
      t.string :address, null: false
      t.string :image
      t.string :attachment_file
      t.string :link, null: false
      t.belongs_to :organizer, null: false, index: true
      t.timestamps
    end
  end
end
