class ExportsController < ApplicationController
  def show
    @html_template = Settings.single_clipping_html_template
    @title_template = Settings.book_title_html_template
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

  def update_html_settings
    Settings.single_clipping_html_template = params[:template]
    Settings.book_title_html_template = params[:title_template]
    flash[:success] = "HTML clipping template updated."
    redirect_to export_path
  end
end
