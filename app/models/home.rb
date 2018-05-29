class Home < ApplicationRecord
  belongs_to :game
  has_many :home_edits

  def editsSorted
    self.home_edits.sort_by{|edit| edit.created_at}
  end

  def approvedEdits
    self.editsSorted.select{|edit| edit.status == "approved"}
  end

  def latestApprovedEdit
    self.approvedEdits.last
  end
end
