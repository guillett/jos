class JarticlesController < ApplicationController
  def show
    @jarticle = Jarticle.where(id_jarticle_origin: params[:id_jarticle_origin]).first
    @jarticle_text = ""
    @jarticle.text.each_line {|line|  @jarticle_text += line.strip + "\n"}
    @jarticle_text = @jarticle_text.strip.chomp.gsub(/\n/, "<br/>").gsub(/« Art/, "<br/>« Art")
  end
end
