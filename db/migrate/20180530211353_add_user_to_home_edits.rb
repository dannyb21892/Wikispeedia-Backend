class AddUserToHomeEdits < ActiveRecord::Migration[5.1]
  def change
    add_column :home_edits, :user_id, :integer
  end
end
