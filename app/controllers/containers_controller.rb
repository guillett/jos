class ContainersController < ApplicationController
  def index
    @containers = Jorfcont.order(:publication_date).where("title LIKE ?", "%JORF%")
  end

  def show
    @container = Jorfcont.find_by(id_jorfcont_origin: params[:id])
  end
end
