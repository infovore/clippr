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

  def edit
    @book_name = @book.book_name
  end

  def update
    @book_name = @book.book_name
    @book_name.display_name = params[:book][:display_name]
    @book_name.save
    redirect_to @book
    #render :text => params.inspect
  end
  
  private
  
  def scope_to_book
    @book = Book.where("book_names.slug" => params[:id]).joins(:book_name).includes([:clippings, :notes]).first
  end
  
end
