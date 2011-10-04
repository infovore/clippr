class ClippingsController < ApplicationController
  def index
    @clippings = Clipping.page(params[:page])
  end
end
