class ImportsController < ApplicationController
  
  def create
    if params[:import] && params[:import][:import_file]
      begin
        Import.perform_import_from_raw_text(params[:import][:import_file].read)
        redirect_to "/"
      rescue Errno::ENOENT
        # render error page
        render :action => "error"
      end
    else
      # path = File.join(Rails.root, "data", "My Clippings.txt")
      path = "/Volumes/Kindle/documents/My\ Clippings.txt"
      begin
        Import.perform_import_from_file(path)
        redirect_to "/"
      rescue Errno::ENOENT
        # render error page
        render :action => "error"
      end
    end
  end
end
