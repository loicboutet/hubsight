require 'ostruct'

class Mockups::SitesController < ApplicationController
  def index
    # Renders sites/index.html.erb
  end

  def show
    @site = OpenStruct.new(
      id: params[:id],
      name: "Centre Commercial Odysseum",
      code: "CCO-001",
      site_type: "commercial",
      total_area: 65000,
      estimated_area: 68000,
      address: "2 Place de Lisbonne",
      city: "Montpellier",
      postal_code: "34000",
      department: "34",
      region: "occitanie",
      country: "France",
      site_manager: "Marie Dubois",
      contact_email: "marie.dubois@odysseum.fr",
      contact_phone: "+33 4 67 13 50 00",
      status: "active",
      description: "Grand centre commercial avec zones commerciales et loisirs",
      cadastral_id: "34000-001-AB-1234",
      rnb_id: "RNB-34-MTL-001",
      gps_coordinates: "43.6055° N, 3.9197° E",
      climate_zone: "H3 - Zone méditerranéenne",
      buildings_count: 2,
      buildings_names: ["Bâtiment A - Principal", "Bâtiment B - Annexe"]
    )
    
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
        name: "Marie Dubois",
        role: "Responsable de Site",
        phone: "+33 4 67 13 50 00",
        email: "marie.dubois@odysseum.fr",
        organization: "Centre Commercial Odysseum"
      },
      {
        name: "Jean Martin",
        role: "Responsable Technique",
        phone: "+33 4 67 13 50 01",
        email: "jean.martin@odysseum.fr",
        organization: "Centre Commercial Odysseum"
      },
      {
        name: "Sophie Bernard",
        role: "Responsable Sécurité",
        phone: "+33 4 67 13 50 02",
        email: "sophie.bernard@odysseum.fr",
        organization: "Centre Commercial Odysseum"
      }
    ]
  end

  def new
    @site = OpenStruct.new(
      name: "",
      code: "",
      site_type: "",
      total_area: nil,
      address: "",
      city: "",
      postal_code: "",
      department: "",
      region: "",
      country: "France",
      site_manager: "",
      contact_email: "",
      contact_phone: "",
      status: "active",
      description: ""
    )
  end

  def create
    # Handle site creation
    redirect_to sites_path, notice: "Site créé avec succès"
  end

  def edit
    @site = OpenStruct.new(
      id: params[:id],
      name: "Centre Commercial Odysseum",
      code: "CCO-001",
      site_type: "commercial",
      total_area: 65000,
      address: "2 Place de Lisbonne",
      city: "Montpellier",
      postal_code: "34000",
      department: "34",
      region: "occitanie",
      country: "France",
      site_manager: "Marie Dubois",
      contact_email: "marie.dubois@odysseum.fr",
      contact_phone: "+33 4 67 13 50 00",
      status: "active",
      description: "Grand centre commercial avec zones commerciales et loisirs"
    )
  end

  def update
    # Handle site update
    redirect_to site_path(params[:id]), notice: "Site mis à jour avec succès"
  end

  def destroy
    # Handle site deletion
    redirect_to sites_path, notice: "Site supprimé avec succès"
  end
end
