module Admin
  class OrganizationsController < ApplicationController
    include AdminAuthorization
    
    layout 'admin'
    before_action :set_organization, only: [:show, :edit, :update, :destroy, :toggle_status]
    
    # GET /admin/organizations
    def index
      @organizations = Organization.order(created_at: :desc)
      
      # Apply status filter if provided
      if params[:status].present? && ['active', 'inactive'].include?(params[:status])
        @organizations = @organizations.where(status: params[:status])
      end
      
      # Apply search filter if provided
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @organizations = @organizations.where(
          "name LIKE ? OR legal_name LIKE ? OR siret LIKE ?",
          search_term, search_term, search_term
        )
      end
    end
    
    # GET /admin/organizations/:id
    def show
      @users_count = @organization.users.count
      @portfolio_managers = @organization.users.by_role(User::ROLES[:portfolio_manager])
      @site_managers = @organization.users.by_role(User::ROLES[:site_manager])
    end
    
    # GET /admin/organizations/new
    def new
      @organization = Organization.new
    end
    
    # POST /admin/organizations
    def create
      @organization = Organization.new(organization_params)
      
      if @organization.save
        # Log creation for audit trail (Phase 4 - Item 9)
        Rails.logger.info("Admin #{current_user.email} created organization: #{@organization.name}")
        
        redirect_to admin_organizations_path, 
                    notice: "Organisation créée avec succès."
      else
        render :new, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "Erreur lors de la création: #{e.message}"
      render :new, status: :unprocessable_entity
    end
    
    # GET /admin/organizations/:id/edit
    def edit
    end
    
    # PATCH/PUT /admin/organizations/:id
    def update
      if @organization.update(organization_params)
        # Log update for audit trail (Phase 4 - Item 9)
        Rails.logger.info("Admin #{current_user.email} updated organization: #{@organization.name}")
        
        redirect_to admin_organization_path(@organization), 
                    notice: "Organisation mise à jour avec succès."
      else
        render :edit, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:alert] = "Erreur lors de la mise à jour: #{e.message}"
      render :edit, status: :unprocessable_entity
    end
    
    # DELETE /admin/organizations/:id
    def destroy
      if @organization.users.any?
        redirect_to admin_organization_path(@organization), 
                    alert: "Impossible de supprimer une organisation avec des utilisateurs associés."
        return
      end
      
      organization_name = @organization.name
      
      if @organization.destroy
        # Log deletion for audit trail (Phase 4 - Item 9)
        Rails.logger.info("Admin #{current_user.email} deleted organization: #{organization_name}")
        
        redirect_to admin_organizations_path, 
                    notice: "Organisation supprimée avec succès."
      else
        redirect_to admin_organization_path(@organization), 
                    alert: "Erreur lors de la suppression de l'organisation."
      end
    end
    
    # POST /admin/organizations/:id/toggle_status
    def toggle_status
      new_status = @organization.active? ? 'inactive' : 'active'
      
      if @organization.update(status: new_status)
        # Log status change for audit trail (Phase 4 - Item 9)
        Rails.logger.info("Admin #{current_user.email} changed organization #{@organization.name} status to: #{new_status}")
        
        redirect_to admin_organization_path(@organization), 
                    notice: "Statut de l'organisation mis à jour avec succès."
      else
        redirect_to admin_organization_path(@organization), 
                    alert: "Erreur lors de la mise à jour du statut."
      end
    end
    
    private
    
    def set_organization
      @organization = Organization.find(params[:id])
    end
    
    def organization_params
      params.require(:organization).permit(
        :name,
        :legal_name,
        :siret,
        :status
      )
    end
  end
end
