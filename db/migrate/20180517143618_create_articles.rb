class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.integer :heading_id
      t.string :content

      t.timestamps
    end
  end
end
