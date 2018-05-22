class AddArticleIdToEdits < ActiveRecord::Migration[5.1]
  def change
    add_column :edits, :article_id, :integer
  end
end
