class CreateEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :edits do |t|
      t.string :title
      t.string :content
      t.string :html_content
      t.string :status

      t.timestamps
    end
  end
end
