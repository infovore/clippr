class ExportsController < ApplicationController
  def show
  end

  def download 
    if params[:start_date] && params[:end_date]
      # TODO: there has to be a more native way of interpreting those bloody
      # date selects
      start_date = [params[:start_date]["(1i)"], params[:start_date]["(2i)"], params[:start_date]["(3i)"]].join("-")
      end_date = [params[:end_date]["(1i)"], params[:end_date]["(2i)"], params[:end_date]["(3i)"]].join("-")
      @clippings = Clipping.where("created_at >= ?", start_date).where("created_at < ?", end_date) 
    else
      @clippings = Clipping.all
    end
    # render clippings as xml
    #render :xml => @clippings.to_xml(:include => {:instapaper_references_controller => {}, :book => {:include => :author}})
    render :xml => @clippings.to_xml_for_export
  end
end
