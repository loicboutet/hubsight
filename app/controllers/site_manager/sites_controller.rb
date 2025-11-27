class SiteManager::SitesController < ApplicationController
  include SiteManagerAuthorization
  
  before_action :authenticate_user!
  before_action :ensure_site_manager_role
  before_action :set_site, only: [:show, :equipment]
  
  def index
    @sites = current_user.assigned_sites
                        .includes(:buildings)
                        .order(:name)
                        .page(params[:page])
                        .per(10)
    
    # Check if site manager has any assigned sites
    unless has_assigned_sites?
      flash.now[:alert] = "Aucun site ne vous a été assigné. Veuillez contacter votre gestionnaire de portefeuille."
    end
  end

  def show
    @opening_hours = [
      { day: "Lundi", open: true, from: "08:00", to: "20:00" },
      { day: "Mardi", open: true, from: "08:00", to: "20:00" },
      { day: "Mercredi", open: true, from: "08:00", to: "20:00" },
      { day: "Jeudi", open: true, from: "08:00", to: "20:00" },
      { day: "Vendredi", open: true, from: "08:00", to: "20:00" },
      { day: "Samedi", open: true, from: "09:00", to: "21:00" },
      { day: "Dimanche", open: true, from: "10:00", to: "19:00" },
      { day: "Jours fériés", open: false, from: "Fermé", to: "Fermé" }
    ]
    
    @contacts = [
      {
        name: @site.site_manager || "N/A",
        role: "Responsable de Site",
        phone: @site.contact_phone || "N/A",
        email: @site.contact_email || "N/A",
        organization: @site.name
      }
    ]
  end

  def equipment
    @equipment = [] # TODO: Load equipment for this site when equipment model is implemented
  end
  
  private
  
  def ensure_site_manager_role
    unless current_user.site_manager?
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end
  
  def set_site
    @site = current_user.assigned_sites.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to my_sites_path, alert: "Vous n'avez pas accès à ce site."
  end
end
