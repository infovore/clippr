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
      start_datetime = DateTime.parse(start_date)
      end_datetime = DateTime.parse(end_date)
      @clippings = Clipping.where("clipped_at >= ?", start_datetime).where("clipped_at < ?", end_datetime) 
    else
      @clippings = Clipping.all
    end
    # render clippings as xml
    render :xml => @clippings.to_xml
  end

  def update_html_settings
    Settings.single_clipping_html_template = params[:template]
    Settings.book_title_html_template = params[:title_template]
    flash[:success] = "HTML clipping template updated."
    redirect_to export_path
  end
end
