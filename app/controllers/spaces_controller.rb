class SpacesController < ApplicationController
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
