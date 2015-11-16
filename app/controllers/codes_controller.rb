class CodesController < ApplicationController

  def show
    @code = Code.joins(:sections).where(sections: {state: 'VIGUEUR'}).find_by escape_title: params[:id]
  end
end
