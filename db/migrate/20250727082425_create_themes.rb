class CreateThemes < ActiveRecord::Migration[8.0]
  def change
    create_table :themes do |t|
      t.string :name
      t.string :placeholder_image
      t.text :description

      t.timestamps
    end
  end
end
