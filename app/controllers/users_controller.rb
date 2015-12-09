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

      sql = "select label from keywords group by label"
      @keywords = ActiveRecord::Base.connection.execute(sql).values.flatten

    end
  end

  def update
    # {"label" => "", "_destroy" => "false"}
    inputs = keyword_params.to_h.values[0].values.select{|i| i['_destroy'] == 'false' }

    keywords = inputs.map{|k| Keyword.where(label: k["label"]).first }.compact
    current_user.update(keywords: keywords)

    redirect_to(current_user)
  end

  def keyword_params
    params.require(:user).permit(keywords_attributes: [:id, :label, :_destroy])
  end
end
