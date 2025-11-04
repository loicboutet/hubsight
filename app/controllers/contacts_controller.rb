require 'ostruct'

class ContactsController < ApplicationController
  before_action :set_organization, only: [:index, :new, :create]

  def index
    # Renders contacts/index.html.erb
  end

  def new
    @contact = OpenStruct.new(
      first_name: "",
      last_name: "",
      position: "",
      affiliated_organization: @organization&.name,
      agency_name: "",
      category: "",
      mobile_phone: "",
      email: "",
      secondary_email: "",
      availability: "",
      languages: "",
      notes: ""
    )
    
    # Add necessary methods for form_with compatibility
    def @contact.persisted?
      false
    end
    
    def @contact.model_name
      ActiveModel::Name.new(OpenStruct, nil, "Contact")
    end
    
    # Renders contacts/new.html.erb
  end

  def create
    # Handle contact creation (dummy - just redirect with success message)
    redirect_to organization_contacts_path(@organization), notice: 'Contact créé avec succès.'
  end

  def show
    # Renders contacts/show.html.erb
  end

  def edit
    # Renders contacts/edit.html.erb
  end

  def update
    # Handle contact update
    redirect_to contact_path(params[:id])
  end

  def destroy
    # Handle contact deletion
    redirect_to organization_path(params[:organization_id])
  end

  def search
    # Renders contacts/search.html.erb
  end

  private

  def set_organization
    if params[:organization_id]
      @organization = OpenStruct.new(
        id: params[:organization_id],
        name: "ENGIE Solutions",
        legal_name: "ENGIE Solutions SAS"
      )
      
      # Make to_param return the id for proper URL generation
      def @organization.to_param
        id.to_s
      end
    end
  end
end
