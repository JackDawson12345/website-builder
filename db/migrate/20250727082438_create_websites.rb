class CreateWebsites < ActiveRecord::Migration[8.0]
  def change
    create_table :websites do |t|
      t.references :user, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true
      t.string :name
      t.string :subdomain
      t.boolean :published

      t.timestamps
    end
  end
end
