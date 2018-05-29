class CreateHomeEdits < ActiveRecord::Migration[5.1]
  def change
    create_table :home_edits do |t|
      t.string :title
      t.string :content
      t.string :htmml_content
      t.string :status

      t.timestamps
    end
  end
end
