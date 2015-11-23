class CodesController < ApplicationController

  def show
    @code = Code.find_by escape_title: params[:id]
  end
end
