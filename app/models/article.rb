class Article < ApplicationRecord
  belongs_to :heading
  has_many :edits
  has_one :article_slug

  def editsSorted
    self.edits.sort_by{|edit| edit.created_at}
  end

  def approvedEdits
    self.editsSorted.select{|edit| edit.status == "approved"}
  end

  def latestApprovedEdit
    self.approvedEdits.last
  end
end
