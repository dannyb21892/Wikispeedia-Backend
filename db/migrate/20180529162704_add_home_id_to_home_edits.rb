class AddHomeIdToHomeEdits < ActiveRecord::Migration[5.1]
  def change
    add_column :home_edits, :home_id, :integer
  end
end
