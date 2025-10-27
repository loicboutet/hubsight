class LevelsController < ApplicationController
  def edit
    # Renders levels/edit.html.erb
  end

  def update
    # Handle level update
    redirect_to building_path(params[:building_id])
  end

  def destroy
    # Handle level deletion
    redirect_to building_path(params[:building_id])
  end
end
