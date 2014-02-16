class ImportsController < ApplicationController
  
  def create
    if params[:import] && params[:import][:import_file]
      
      begin
        raw_text = File.read(params[:import][:import_file].tempfile.path, :encoding => 'UTF-8')
        new_items_count = Import.perform_import_from_raw_text(raw_text)

        flash[:success] = "#{help.pluralize(new_items_count, "new item")} imported."
        redirect_to "/"
      rescue Errno::ENOENT
        # render error page
        render :action => "error"
      end
    else
      path = "/Volumes/Kindle/documents/My\ Clippings.txt"
      begin
        new_items_count = Import.perform_import_from_file(path)
        flash[:success] = "#{help.pluralize(new_items_count, "new item")} imported."
        redirect_to "/"
      rescue Errno::ENOENT
        # render error page
        render :action => "error"
      end
    end
  end
end
