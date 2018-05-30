class Edit < ApplicationRecord
  belongs_to :article
  belongs_to :user

  def self.allSortedApprovedEdits
    edits = Edit.all.select{|edit| edit.status === "approved" && edit.article}.sort_by{|edit| edit.created_at}.reverse
    output = []
    i = 0
    edits.each do |e|
      if (i < 20) && (e.article)
        output.push(edits[i])
      end
      i = i+1
    end
    output
  end
end
