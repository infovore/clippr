class BooksController < ApplicationController
  before_filter :scope_to_book, :only => [:show]
  
  def index
    @books = Book.all
  end
  
  def show
    respond_to do |format|
      format.html
      format.xml do 
        render :xml => @book.clippings.to_xml(:include => {:instapaper_reference => {}, :book => {:include => :author}})
      end
    end
  end
  
  private
  
  def scope_to_book
    @book = Book.where("book_names.slug" => params[:id]).joins(:book_name).includes([:clippings, :notes]).first
  end
  
end
