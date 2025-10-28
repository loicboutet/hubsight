class Api::AlertsController < ApplicationController
  def count
    # Returns alerts count as JSON
    render json: { count: 0 }
  end
end
