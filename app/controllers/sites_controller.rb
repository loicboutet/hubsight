class SitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :authorize_portfolio_manager, except: [:index, :show]
  
  def index
    @sites = current_user.sites
                        .includes(:buildings)
                        .page(params[:page])
                        .per(10)
    
    # Apply filters
    @sites = @sites.search_by_name(params[:search]) if params[:search].present?
    @sites = @sites.search_by_city(params[:search]) if params[:search].present?
    @sites = @sites.by_type(params[:site_type]) if params[:site_type].present?
    @sites = @sites.by_region(params[:region]) if params[:region].present?
    
    # Apply sorting
    case params[:sort_by]
    when 'area'
      @sites = @sites.order(total_area: :desc)
    when 'buildings_count'
      @sites = @sites.left_joins(:buildings).group(:id).order('COUNT(buildings.id) DESC')
    else
      @sites = @sites.ordered_by_name
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

  def new
    @site = current_user.sites.build(status: 'active', country: 'France')
  end

  def create
    @site = current_user.sites.build(site_params)
    
    if @site.save
      redirect_to sites_path, notice: "Site créé avec succès"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @site.update(site_params)
      redirect_to site_path(@site), notice: "Site mis à jour avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @site.destroy
      redirect_to sites_path, notice: "Site supprimé avec succès"
    else
      redirect_to sites_path, alert: "Impossible de supprimer le site"
    end
  end
  
  private
  
  def set_site
    @site = current_user.sites.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to sites_path, alert: "Site introuvable"
  end
  
  def authorize_portfolio_manager
    unless current_user.admin? || current_user.portfolio_manager?
      redirect_to sites_path, alert: "Vous n'avez pas l'autorisation d'effectuer cette action"
    end
  end
  
  def site_params
    params.require(:site).permit(
      :name,
      :code,
      :site_type,
      :status,
      :description,
      :address,
      :city,
      :postal_code,
      :department,
      :region,
      :country,
      :total_area,
      :estimated_area,
      :site_manager,
      :contact_email,
      :contact_phone,
      :gps_coordinates,
      :climate_zone,
      :cadastral_id,
      :rnb_id
    )
  end
end
