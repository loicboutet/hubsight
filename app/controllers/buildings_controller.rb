require 'ostruct'

# TODO: Remove this MockModel class and all mock data when implementing actual Building and Site models
# This is a temporary solution to make forms work with form_with until the database models are created
class MockModel
  include ActiveModel::Model
  include ActiveModel::Conversion
  
  attr_accessor :id, :name, :code, :area, :construction_year, :status, :description, :site_id,
                :cadastral_reference, :renovation_year, :number_of_levels, :height, :structure_type,
                :erp_category, :erp_type, :capacity, :pmr_accessibility, :environmental_certification,
                :energy_consumption, :dpe_rating, :ghg_rating, :notes
  
  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
    @new_record = attributes[:id].nil?
  end
  
  def persisted?
    !@new_record
  end
  
  def new_record?
    @new_record
  end
  
  def to_key
    persisted? ? [id] : nil
  end
  
  def model_name
    ActiveModel::Name.new(self.class, nil, self.class.name.gsub('Mock', ''))
  end
end

class BuildingsController < ApplicationController
  def index
    @site = OpenStruct.new(id: params[:site_id], name: "Tour Montparnasse")
    @buildings = [
      OpenStruct.new(
        id: 1,
        name: "Bâtiment A - Principal",
        code: "BAT-A",
        area: 12500,
        levels_count: 8,
        spaces_count: 98,
        equipment_count: 187,
        construction_year: 2005,
        status: "active"
      ),
      OpenStruct.new(
        id: 2,
        name: "Bâtiment B - Annexe",
        code: "BAT-B",
        area: 8200,
        levels_count: 4,
        spaces_count: 58,
        equipment_count: 137,
        construction_year: 2010,
        status: "active"
      )
    ]
  end

  def show
    @building = Building.find(params[:id])
    @site = @building.site
    @levels = @building.levels.ordered
    
    # Ensure user has access to this building's organization
    # Admins can access all buildings across all organizations
    unless current_user.admin? || @building.organization_id == current_user.organization_id
      redirect_to root_path, alert: "Accès non autorisé."
    end
  end

  def new
    @site = Site.find(params[:site_id])
    @building = @site.buildings.build(
      construction_year: Time.current.year,
      status: "active"
    )
  end

  def create
    @site = Site.find(params[:site_id])
    @building = @site.buildings.build(building_params)
    @building.user = current_user  # Track who created it
    @building.organization = @site.organization  # Inherit organization from site
    
    if @building.save
      redirect_to site_path(@site), notice: "Bâtiment créé avec succès"
    else
      flash.now[:alert] = "Erreur lors de la création du bâtiment : #{@building.errors.full_messages.join(', ')}"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @building = Building.find(params[:id])
    @site = @building.site
  end

  def update
    @building = Building.find(params[:id])
    @site = @building.site
    
    if @building.update(building_params)
      redirect_to site_path(@site), notice: "Bâtiment mis à jour avec succès"
    else
      flash.now[:alert] = "Erreur lors de la mise à jour du bâtiment : #{@building.errors.full_messages.join(', ')}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Handle building deletion
    site_id = params[:site_id] || 1
    redirect_to site_path(site_id), notice: "Bâtiment supprimé avec succès"
  end

  private

  def building_params
    params.require(:building).permit(
      :name,
      :cadastral_reference,
      :construction_year,
      :renovation_year,
      :area,
      :number_of_levels,
      :height_m,
      :structure_type,
      :erp_category,
      :erp_type,
      :capacity,
      :pmr_accessibility,
      :environmental_certification,
      :energy_consumption,
      :dpe_rating,
      :ghg_rating,
      :notes
    )
  end
end
