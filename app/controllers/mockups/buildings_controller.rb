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

class Mockups::BuildingsController < ApplicationController
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
    @building = OpenStruct.new(
      id: params[:id],
      name: "Bâtiment A - Principal",
      code: "BAT-A",
      area: 12500,
      construction_year: 2005,
      status: "active",
      description: "Bâtiment principal avec zones commerciales et bureaux",
      site_id: params[:site_id] || 1
    )
    @site = OpenStruct.new(id: @building.site_id, name: "Tour Montparnasse")
  end

  def new
    @site = MockModel.new(id: params[:site_id], name: "Tour Montparnasse")
    def @site.model_name
      ActiveModel::Name.new(self.class, nil, "Site")
    end
    
    @building = MockModel.new(
      name: "",
      code: "",
      area: nil,
      construction_year: Time.current.year,
      status: "active",
      description: ""
    )
    def @building.model_name
      ActiveModel::Name.new(self.class, nil, "Building")
    end
  end

  def create
    # Handle building creation
    redirect_to site_path(params[:site_id]), notice: "Bâtiment créé avec succès"
  end

  def edit
    @building = MockModel.new(
      id: params[:id],
      name: "Bâtiment A - Principal",
      code: "BAT-A",
      area: 12500,
      construction_year: 2005,
      status: "active",
      description: "Bâtiment principal avec zones commerciales et bureaux",
      site_id: 1
    )
    def @building.model_name
      ActiveModel::Name.new(self.class, nil, "Building")
    end
    
    @site = MockModel.new(id: @building.site_id, name: "Tour Montparnasse")
    def @site.model_name
      ActiveModel::Name.new(self.class, nil, "Site")
    end
  end

  def update
    # Handle building update
    redirect_to building_path(params[:id]), notice: "Bâtiment mis à jour avec succès"
  end

  def destroy
    # Handle building deletion
    site_id = params[:site_id] || 1
    redirect_to site_path(site_id), notice: "Bâtiment supprimé avec succès"
  end
end
