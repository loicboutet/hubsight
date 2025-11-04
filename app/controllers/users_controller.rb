class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    # For admin: show portfolio managers
    # For portfolio managers: show site managers of their organization
    @users = User.all # TODO: Add proper scoping based on user role
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      redirect_to users_path, notice: "Utilisateur créé avec succès."
    else
      render :new, alert: "Erreur lors de la création de l'utilisateur."
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "Utilisateur mis à jour avec succès."
    else
      render :edit, alert: "Erreur lors de la mise à jour de l'utilisateur."
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "Utilisateur supprimé avec succès."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :role, :active)
  end
end
