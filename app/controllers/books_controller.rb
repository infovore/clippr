class BooksController < ApplicationController
  before_filter :scope_to_book, :only => [:show]
  
  def index
    @books = Book.all
  end
  
  def show
    
  end
  
  private
  
  def scope_to_book
    @book = Book.find(params[:id])
  end
  
end
