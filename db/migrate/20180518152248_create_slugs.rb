class CreateSlugs < ActiveRecord::Migration[5.1]
  def change
    create_table :slugs do |t|
      t.string :name
      t.integer :game_id

      t.timestamps
    end
  end
end
