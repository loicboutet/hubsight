class Api::EquipmentController < ApplicationController
  def contracts
    # Returns contracts for equipment as JSON
    render json: { contracts: [] }
  end
end
