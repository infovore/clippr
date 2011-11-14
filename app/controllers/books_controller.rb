class BooksController < ApplicationController
  before_filter :scope_to_book, :only => [:show, :edit, :update, :html_export]
  
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

  def html_export
    output = ""
    output << @book.title_and_author_for_html(Settings.book_title_html_template)
    @book.clippings.each do |clipping|
      output << clipping.to_templated_html(Settings.single_clipping_html_template)
    end
    render :text => output
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
