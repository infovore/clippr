class ImportsController < ApplicationController
  
  def create
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
