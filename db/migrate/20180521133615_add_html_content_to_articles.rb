class AddHtmlContentToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :html_content, :string
  end
end
