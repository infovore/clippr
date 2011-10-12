class BooksController < ApplicationController
  before_filter :scope_to_book, :only => [:show, :edit, :update]
  
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

  def update
    @book.display_name = params[:book][:display_name]
    @book.save
    redirect_to [@book.author, @book]
  end
  
  private
  
  def scope_to_book
    @book = Book.where(:slug => params[:id]).includes([:clippings, :notes]).first
  end
  
end
