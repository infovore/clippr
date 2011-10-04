class ClippingsController < ApplicationController
  def index
    @clippings = Clipping.all
  end
end
