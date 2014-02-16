class AuthorsController < ApplicationController
  before_filter :scope_to_author, :only => [:show]

  def index
    @authors = Author.all
    respond_to do |format|
      format.html
      format.json { render :json => @authors }
    end
  end
  
  def show
    
  end
  
  private
  
  def scope_to_author
    @author = Author.find(params[:id], :include => :books)
  end
  
  
end
