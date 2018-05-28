class Api::V1::EditsController < ApplicationController
  def index
    edits = Edit.allSortedApprovedEdits
    render json: {
      success: !!edits,
      edits: edits
    }
  end
end
