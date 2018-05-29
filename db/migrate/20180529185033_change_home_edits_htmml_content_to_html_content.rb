class ChangeHomeEditsHtmmlContentToHtmlContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :home_edits, :htmml_content, :html_content
  end
end
