class ContainersController < ApplicationController
  def index
    @containers = Jorfcont.where('publication_date <= ?', Date.today).order(publication_date: :desc).where("title LIKE ?", "%JORF%")
    @containers = @containers.page params[:page]
  end

  def show
    @container = Jorfcont.find_by(id_jorfcont_origin: params[:id])
  end
end
