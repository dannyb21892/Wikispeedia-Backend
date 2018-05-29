class CreateHomes < ActiveRecord::Migration[5.1]
  def change
    create_table :homes do |t|
      t.string :title
      t.integer :game_id
      t.string :content
      t.string :html_content

      t.timestamps
    end
  end
end
