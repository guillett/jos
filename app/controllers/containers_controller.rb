class ContainersController < ApplicationController
  def index
    @containers = Jorfcont.order(:title)
  end

  def show
    @container = Jorfcont.find_by(id_jorfcont_origin: params[:id])
  end
end
