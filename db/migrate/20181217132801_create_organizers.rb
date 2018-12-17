class CreateOrganizers < ActiveRecord::Migration[5.2]
  def change
    create_table :organizers do |t|
      t.string :name, null: false, unique: true
      t.text   :desc, null: false
      t.timestamps
    end
  end
end
