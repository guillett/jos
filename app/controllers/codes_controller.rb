class CodesController < ApplicationController

  def show
    @code = Code.joins(sections: :articles).where(sections: {state: 'VIGUEUR'}, articles: {state: 'VIGUEUR'}).find_by escape_title: params[:id]
  end
end
