class ExportsController < ApplicationController
  def show
  end

  def download 
    if params[:start_date] && params[:end_date]
      @clippings = Clipping.where("state_date >= ?", params[:start_date]).where("end_date < ?", params[:end_date])
    else
      @clippings = Clipping.all
    end
    # render clippings as xml
    render :xml => @clippings.to_xml
  end
end
