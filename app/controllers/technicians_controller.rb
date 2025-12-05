class TechniciansController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :set_technician, only: [:show, :edit, :update, :destroy, :resend_invitation]

  def index
    # Site managers see only technicians from their organization
    @technicians = User.by_role(User::ROLES[:technician])
                       .where(organization_id: current_user.organization_id)
                       .order(created_at: :desc)
                       .page(params[:page])
                       .per(10)
  end

  def show
  end

  def new
    @technician = User.new(
      role: User::ROLES[:technician],
      organization_id: current_user.organization_id
    )
  end

  def create
    @technician = User.new(technician_params)
    @technician.role = User::ROLES[:technician]
    @technician.organization_id = current_user.organization_id
    @technician.invited_by = current_user
    @technician.status = 'active'
    
    # Skip password validation - user will set it via invitation
    @technician.password = SecureRandom.hex(20)
    @technician.password_confirmation = @technician.password
    
    ActiveRecord::Base.transaction do
      if @technician.save(validate: false)
        # Generate invitation token and send email
        @technician.generate_invitation_token!
        @technician.send_invitation_email
        
        redirect_to technicians_path, 
                    notice: "Technicien créé avec succès. Invitation envoyée à #{@technician.email}."
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = "Erreur lors de la création: #{e.message}"
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    update_params = technician_params
    
    # Remove password params if blank
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end
    
    # Ensure organization_id cannot be changed
    update_params.delete(:organization_id)
    
    if @technician.update(update_params)
      redirect_to technicians_path, notice: "Technicien mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @technician.destroy
    redirect_to technicians_path, notice: "Technicien supprimé avec succès."
  end

  def resend_invitation
    if @technician.invitation_pending?
      # Generate new invitation token and resend email
      @technician.generate_invitation_token!
      @technician.send_invitation_email
      
      # Log for audit trail
      Rails.logger.info("Site Manager #{current_user.email} resent invitation to: #{@technician.email}")
      
      redirect_to technician_path(@technician), 
                  notice: "Invitation renvoyée avec succès à #{@technician.email}."
    else
      redirect_to technician_path(@technician), 
                  alert: "Cette invitation a déjà été acceptée."
    end
  end

  private

  def set_technician
    # Site managers can only access technicians from their organization
    @technician = User.by_role(User::ROLES[:technician])
                     .where(organization_id: current_user.organization_id)
                     .find(params[:id])
  end

  def technician_params
    params.require(:user).permit(
      :email, 
      :first_name, 
      :last_name, 
      :phone, 
      :department,
      :status,
      :password,
      :password_confirmation
    )
  end
end
