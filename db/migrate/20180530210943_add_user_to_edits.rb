class AddUserToEdits < ActiveRecord::Migration[5.1]
  def change
    add_column :edits, :user_id, :integer
  end
end
