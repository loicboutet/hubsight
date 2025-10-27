class Api::SitesController < ApplicationController
  def hierarchy
    # Returns site hierarchy as JSON
    render json: { hierarchy: [] }
  end
end
