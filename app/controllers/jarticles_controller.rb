class JarticlesController < ApplicationController
  def show
    @jarticle = Jarticle.where(id_jarticle_origin: params[:id_jarticle_origin]).first
  end
end
