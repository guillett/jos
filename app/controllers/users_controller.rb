class UsersController < ApplicationController

  before_action :authenticate_user!

  def edit 
    if current_user.id != params[:id].to_i
      redirect_to root_path, notice: "Vous ne pouvez voir que votre propre profil"
    else
    end
  end

  def show
    if current_user.id != params[:id].to_i
      redirect_to root_path, notice: "Vous ne pouvez voir que votre propre profil"
    else

    end
  end
end
