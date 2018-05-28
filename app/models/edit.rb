class Edit < ApplicationRecord
  belongs_to :article

  def self.allSortedApprovedEdits
    Edit.all.select{|edit| edit.status === "approved"}.sort_by{|edit| edit.created_at}
  end
end
