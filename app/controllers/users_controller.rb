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

  def update
    keywords = keyword_params.to_h.values.map{|k| Keyword.where(label: k.values[0]["label"]).first }.compact

    current_user.keywords += keywords

    redirect_to(current_user)
  end

  def keyword_params
    params.require(:user).permit(keywords_attributes: [:id, :label, :_destroy])
  end
end
