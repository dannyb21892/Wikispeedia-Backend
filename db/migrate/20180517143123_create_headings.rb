class CreateHeadings < ActiveRecord::Migration[5.1]
  def change
    create_table :headings do |t|
      t.string :name
      t.integer :game_id

      t.timestamps
    end
  end
end
