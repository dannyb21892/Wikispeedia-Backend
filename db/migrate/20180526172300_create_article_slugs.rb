class CreateArticleSlugs < ActiveRecord::Migration[5.1]
  def change
    create_table :article_slugs do |t|
      t.integer :article_id
      t.string :name

      t.timestamps
    end
  end
end
