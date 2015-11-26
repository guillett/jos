class CodesController < ApplicationController

  def index
    @codes = Code.order(:title)
  end

  def show
    @code = Code.find_by escape_title: params[:id]
  end
end
