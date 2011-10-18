class ClippingsController < ApplicationController
  before_filter :scope_to_clipping, :except => [:index]

  def index
    @clippings = Clipping.page(params[:page])
  end

  def html_export
    render :text => @clipping.to_templated_html(Settings.single_clipping_html_template)
  end
  
  private

  def scope_to_clipping
    @clipping = Clipping.find(params[:id])
  end
end
