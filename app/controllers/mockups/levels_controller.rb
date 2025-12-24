require 'ostruct'

# TODO: Remove this MockModel class and all mock data when implementing actual Level and Building models
# This is a temporary solution to make forms work with form_with until the database models are created
class MockModel
  include ActiveModel::Model
  include ActiveModel::Conversion
  
  attr_accessor :id, :name, :area, :description, :building_id, :level_number,
                :altitude, :spaces_count, :equipment_count
  
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

class Mockups::LevelsController < ApplicationController
  def index
    @building = OpenStruct.new(id: params[:building_id], name: "Bâtiment A - Principal")
    @levels = [
      OpenStruct.new(
        id: 1,
        name: "Rez-de-chaussée",
        level_number: 0,
        area: 1800,
        spaces_count: 15,
        equipment_count: 28
      ),
      OpenStruct.new(
        id: 2,
        name: "1er étage",
        level_number: 1,
        area: 1600,
        spaces_count: 12,
        equipment_count: 24
      )
    ]
  end

  def new
    @building = MockModel.new(id: params[:building_id], name: "Bâtiment A - Principal")
    def @building.model_name
      ActiveModel::Name.new(self.class, nil, "Building")
    end
    
    @level = MockModel.new(
      name: "",
      level_number: 0,
      area: nil,
      description: ""
    )
    def @level.model_name
      ActiveModel::Name.new(self.class, nil, "Level")
    end
  end

  def create
    # Handle level creation
    redirect_to building_path(params[:building_id]), notice: "Niveau créé avec succès"
  end

  def show
    @level = OpenStruct.new(
      id: params[:id],
      name: "Rez-de-chaussée",
      level_number: 0,
      area: 1800,
      altitude: 0,
      spaces_count: 15,
      equipment_count: 28,
      building_id: 1
    )
    @building = OpenStruct.new(id: @level.building_id, name: "Bâtiment A - Principal")
    @site = OpenStruct.new(id: 1, name: "Tour Montparnasse")
  end

  def edit
    @level = MockModel.new(
      id: params[:id],
      name: "Rez-de-chaussée",
      level_number: 0,
      area: 1800,
      description: "Niveau principal avec accueil et commerces",
      building_id: params[:building_id] || 1
    )
    def @level.model_name
      ActiveModel::Name.new(self.class, nil, "Level")
    end
    
    @building = MockModel.new(id: @level.building_id, name: "Bâtiment A - Principal")
    def @building.model_name
      ActiveModel::Name.new(self.class, nil, "Building")
    end
  end

  def update
    # Handle level update
    redirect_to building_path(params[:building_id]), notice: "Niveau mis à jour avec succès"
  end

  def destroy
    # Handle level deletion
    redirect_to building_path(params[:building_id]), notice: "Niveau supprimé avec succès"
  end
end
