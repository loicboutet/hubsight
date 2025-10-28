class Api::AutocompleteController < ApplicationController
  def equipment_types
    # Returns equipment types for autocomplete as JSON
    render json: { results: [] }
  end

  def organizations
    # Returns organizations for autocomplete as JSON
    render json: { results: [] }
  end

  def contacts
    # Returns contacts for autocomplete as JSON
    render json: { results: [] }
  end
end
