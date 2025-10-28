require 'ostruct'

# TODO: Remove this MockModel class and all mock data when implementing actual Space model
# This is a temporary solution to make forms work with form_with until the database models are created
class MockModel
  include ActiveModel::Model
  include ActiveModel::Conversion
  
  attr_accessor :id, :name, :space_type, :area, :capacity, :description, :level_id
  
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

class SpacesController < ApplicationController
  def index
    @level = OpenStruct.new(id: params[:level_id], name: "Rez-de-chaussée")
    @spaces = [
      OpenStruct.new(
        id: 'space-101',
        name: 'Bureau 101',
        type: 'Bureau',
        area: 25,
        capacity: 2,
        equipment_count: 3
      ),
      OpenStruct.new(
        id: 'space-102',
        name: 'Bureau 102',
        type: 'Bureau',
        area: 25,
        capacity: 2,
        equipment_count: 3
      ),
      OpenStruct.new(
        id: 'space-a',
        name: 'Salle de réunion A',
        type: 'Salle de réunion',
        area: 40,
        capacity: 10,
        equipment_count: 5
      )
    ]
  end

  def new
    # Use MockModel class from levels_controller.rb
    @level = MockModel.new(id: params[:level_id], name: "Rez-de-chaussée")
    def @level.model_name
      ActiveModel::Name.new(self.class, nil, "Level")
    end
    
    @space = MockModel.new(
      name: "",
      space_type: "",
      area: nil,
      capacity: nil,
      description: ""
    )
    def @space.model_name
      ActiveModel::Name.new(self.class, nil, "Space")
    end
  end

  def create
    # Handle space creation
    redirect_to level_path(params[:level_id]), notice: "Espace créé avec succès"
  end

  def show
    # Renders spaces/show.html.erb
  end

  def edit
    # Renders spaces/edit.html.erb
  end

  def update
    # Handle space update
    redirect_to space_path(params[:id])
  end

  def destroy
    # Handle space deletion
    redirect_to level_path(params[:level_id])
  end
end
