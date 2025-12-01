class Api::OrganizationsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  
  # GET /api/organizations/autocomplete
  # Parameters:
  #   - query: search term (required, min 2 chars)
  #   - include_contacts: boolean (optional, default: true)
  #   - include_agencies: boolean (optional, default: true)
  def autocomplete
    query = params[:query].to_s.strip
    
    if query.length < 2
      render json: { organizations: [] }
      return
    end
    
    # Search across ALL organizations (not scoped to current user's org)
    # This is intentional - organizations are shared reference data (service providers, etc.)
    organizations = Organization.active
                                .search(query)
                                .ordered
                                .limit(50)
    
    # Build response with organization details
    results = organizations.map do |org|
      result = {
        id: org.id,
        name: org.name,
        legal_name: org.legal_name,
        display_name: org.display_name,
        organization_type: org.organization_type,
        type_label: org.type_label,
        siret: org.siret,
        formatted_siret: org.formatted_siret,
        phone: org.phone,
        email: org.email,
        website: org.website,
        headquarters_address: org.headquarters_address,
        specialties: org.specialties,
        status: org.status
      }
      
      # Include contacts if requested (default: true)
      if params[:include_contacts] != 'false'
        result[:contacts] = org.contacts.active.ordered.limit(10).map do |contact|
          {
            id: contact.id,
            full_name: contact.full_name,
            display_name: contact.display_name,
            position: contact.position,
            phone: contact.phone,
            mobile: contact.mobile,
            email: contact.email
          }
        end
      end
      
      # Include agencies if requested (default: true)
      if params[:include_agencies] != 'false'
        result[:agencies] = org.agencies.active.ordered.limit(10).map do |agency|
          {
            id: agency.id,
            name: agency.name,
            display_name: agency.display_name,
            city: agency.city,
            phone: agency.phone,
            agency_type: agency.agency_type,
            type_label: agency.type_label
          }
        end
      end
      
      result
    end
    
    render json: { organizations: results }
  rescue => e
    Rails.logger.error "Organizations autocomplete error: #{e.message}"
    render json: { error: e.message }, status: :internal_server_error
  end
end
