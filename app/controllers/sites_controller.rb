class SitesController < ApplicationController
  def index
    # Renders sites/index.html.erb
  end

  def show
    # Renders sites/show.html.erb
  end

  def new
    # Renders sites/new.html.erb
  end

  def create
    # Handle site creation
    redirect_to sites_path
  end

  def edit
    # Renders sites/edit.html.erb
  end

  def update
    # Handle site update
    redirect_to site_path(params[:id])
  end

  def destroy
    # Handle site deletion
    redirect_to sites_path
  end
end
