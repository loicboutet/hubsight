module Api
  class ContractFamiliesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    # GET /api/contract_families/autocomplete
    # Autocomplete search for contract families and subfamilies
    # 
    # Parameters:
    #   - query: search term (minimum 2 characters)
    #   - family: filter by parent family code (optional)
    #
    # Returns: JSON array of matching contract families
    def autocomplete
      query = params[:query].to_s.strip
      family_filter = params[:family].to_s.strip
      
      # Require minimum 2 characters
      if query.length < 2
        render json: []
        return
      end
      
      # Base query: search active records
      results = ContractFamily.active
      
      # Apply family filter if provided
      if family_filter.present?
        results = results.where(parent_code: family_filter)
      end
      
      # Search by code or name
      results = results.where(
        'LOWER(code) LIKE ? OR LOWER(name) LIKE ?',
        "%#{query.downcase}%",
        "%#{query.downcase}%"
      )
      
      # Order: families first, then subfamilies, ordered by display_order and code
      results = results.order(:display_order, :code)
      
      # Limit results
      results = results.limit(50)
      
      # Build JSON response
      render json: results.map { |family| format_family(family) }
    end
    
    private
    
    # Format a contract family for JSON response
    def format_family(family)
      {
        id: family.id,
        code: family.code,
        name: family.name,
        display_name: family.display_name,
        family_type: family.family_type,
        parent_code: family.parent_code,
        hierarchy_path: family.hierarchy_path,
        description: family.description,
        family_badge_color: family.family_badge_color,
        is_family: family.family?,
        is_subfamily: family.subfamily?,
        parent_family_name: family.parent_family&.name
      }
    end
  end
end
