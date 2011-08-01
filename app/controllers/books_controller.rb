class BooksController < ApplicationController
  before_filter :scope_to_book, :only => [:show]
  
  def index
    @books = Book.all
  end
  
  def show
    respond_to do |format|
      format.html
      format.xml do 
        render :xml => @book.clippings.to_xml
      end
    end
  end
  
  private
  
  def scope_to_book
    @book = Book.find(params[:id], :include => [:clippings, :notes])    
  end
  
end
