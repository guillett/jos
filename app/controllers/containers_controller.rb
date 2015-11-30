class ContainersController < ApplicationController
  def index
    @containers = Jorfcont.order(:title)
  end
end
