class CreateThemePages < ActiveRecord::Migration[8.0]
  def change
    create_table :theme_pages do |t|
      t.references :theme, null: false, foreign_key: true
      t.string :page_type
      t.integer :position

      t.timestamps
    end
  end
end
