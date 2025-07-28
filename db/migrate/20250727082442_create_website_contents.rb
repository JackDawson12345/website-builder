class CreateWebsiteContents < ActiveRecord::Migration[8.0]
  def change
    create_table :website_contents do |t|
      t.references :website, null: false, foreign_key: true
      t.references :component, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
