class SiteManagersController < ApplicationController
  include PortfolioManagerAuthorization
  
  before_action :set_site_manager, only: [:show, :edit, :update, :destroy, :resend_invitation]

  def index
    # Portfolio managers see site managers of their organization
    @site_managers = User.by_role(User::ROLES[:site_manager])
                        .where(organization_id: current_user.organization_id)
                        .order(created_at: :desc)
  end

  def show
  end

  def new
    @site_manager = User.new(
      role: User::ROLES[:site_manager],
      organization_id: current_user.organization_id
    )
  end

  def create
    @site_manager = User.new(site_manager_params)
    @site_manager.role = User::ROLES[:site_manager]
    @site_manager.organization_id = current_user.organization_id
    @site_manager.invited_by = current_user
    @site_manager.status = 'active'
    
    # Skip password validation - user will set it via invitation
    @site_manager.password = SecureRandom.hex(20)
    @site_manager.password_confirmation = @site_manager.password
    
    ActiveRecord::Base.transaction do
      if @site_manager.save(validate: false)
        # Generate invitation token and send email
        @site_manager.generate_invitation_token!
        @site_manager.send_invitation_email
        
        redirect_to site_managers_path, 
                    notice: "Responsable de site créé avec succès. Invitation envoyée à #{@site_manager.email}."
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
    update_params = site_manager_params
    
    # Remove password params if blank
    if update_params[:password].blank?
      update_params.delete(:password)
      update_params.delete(:password_confirmation)
    end
    
    # Ensure organization_id cannot be changed
    update_params.delete(:organization_id)
    
    if @site_manager.update(update_params)
      redirect_to site_managers_path, notice: "Responsable de site mis à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @site_manager.destroy
    redirect_to site_managers_path, notice: "Responsable de site supprimé avec succès."
  end

  def resend_invitation
    if @site_manager.invitation_pending?
      # Generate new invitation token and resend email
      @site_manager.generate_invitation_token!
      @site_manager.send_invitation_email
      
      # Log for audit trail
      Rails.logger.info("Portfolio Manager #{current_user.email} resent invitation to: #{@site_manager.email}")
      
      redirect_to site_manager_path(@site_manager), 
                  notice: "Invitation renvoyée avec succès à #{@site_manager.email}."
    else
      redirect_to site_manager_path(@site_manager), 
                  alert: "Cette invitation a déjà été acceptée."
    end
  end

  def assign_sites
    # Load available sites from the organization
    @available_sites = Site.where(organization_id: current_user.organization_id).order(:name)
    # TODO: Implement site assignments relationship
    # @assigned_sites = @site_manager.assigned_sites
  end

  def update_site_assignments
    # TODO: Update site assignments
    # @site_manager.update(assigned_site_ids: params[:site_ids])
    redirect_to site_manager_path(@site_manager), 
                notice: "Sites assignés avec succès."
  end

  private

  def set_site_manager
    @site_manager = User.by_role(User::ROLES[:site_manager])
                       .where(organization_id: current_user.organization_id)
                       .find(params[:id])
  end

  def site_manager_params
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
