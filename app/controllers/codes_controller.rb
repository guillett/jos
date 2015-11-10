class CodesController < ApplicationController

  def show
    @code = Code.includes(:sections).find(params[:id])
  end
end
