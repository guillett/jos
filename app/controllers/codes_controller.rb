class CodesController < ApplicationController

  def show
    @code = Code.joins(:sections).where(sections: {state: 'VIGUEUR'}).find(params[:id])
  end
end
