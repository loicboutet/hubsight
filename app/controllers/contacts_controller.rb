class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  
  def index
    @contacts = Contact.includes(:organization)
                      .ordered
                      .page(params[:page])
                      .per(15)
    
    if params[:search].present?
      @contacts = @contacts.search(params[:search])
    end
  end
  
  def show
  end
  
  def new
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    @contact = @organization ? @organization.contacts.build : Contact.new
  end
  
  def create
    @organization = Organization.find(params[:organization_id]) if params[:organization_id]
    @contact = @organization ? @organization.contacts.build(contact_params) : Contact.new(contact_params)
    
    if @contact.save
      redirect_to @organization || @contact, notice: 'Contact créé avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
  end
  
  def update
    if @contact.update(contact_params)
      redirect_to @contact, notice: 'Contact mis à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  def destroy
    organization = @contact.organization
    @contact.destroy
    redirect_to organization || contacts_path, notice: 'Contact supprimé avec succès.'
  end
  
  def search
    @contacts = Contact.includes(:organization)
                      .search(params[:query])
                      .ordered
                      .limit(10)
    
    render json: @contacts.as_json(
      only: [:id, :first_name, :last_name, :position, :phone, :email],
      methods: [:full_name, :display_name],
      include: {
        organization: { only: [:id, :name] }
      }
    )
  end
  
  private
  
  def set_contact
    @contact = Contact.find(params[:id])
  end
  
  def contact_params
    params.require(:contact).permit(
      :organization_id,
      :first_name,
      :last_name,
      :position,
      :department,
      :phone,
      :mobile,
      :email,
      :availability,
      :languages,
      :notes,
      :status,
      organization_attributes: [:name, :legal_name, :siret, :status]
    )
  end
end
