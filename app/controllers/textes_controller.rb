class TextesController < ApplicationController
  def show
    @jtext= Jtext.find(params[:id])
  end
end