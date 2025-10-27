class BuildingsController < ApplicationController
  def show
    # Renders buildings/show.html.erb
  end

  def edit
    # Renders buildings/edit.html.erb
  end

  def update
    # Handle building update
    redirect_to building_path(params[:id])
  end

  def destroy
    # Handle building deletion
    redirect_to site_path(params[:site_id])
  end
end
