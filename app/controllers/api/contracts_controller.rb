class Api::ContractsController < ApplicationController
  def linked_equipment
    # Returns linked equipment as JSON
    render json: { equipment: [] }
  end
end
