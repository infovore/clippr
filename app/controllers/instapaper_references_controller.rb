class InstapaperReferencesController < ApplicationController
  before_filter :scope_to_clipping

  def new
    if @clipping.instapaper_reference
      @instapaper_reference = @clipping.instapaper_reference
    else
      @instapaper_reference = InstapaperReference.new_for_clipping(@clipping)
    end
    respond_to do |format|
      format.html
      format.json { render :json => @instapaper_reference }
    end
  end

  def create
    ir = @clipping.instapaper_reference

    InstapaperReference.create(:clipping_id => @clipping.id,
                               :title => params[:instapaper_reference][:title],
                               :url => params[:instapaper_reference][:url])

    redirect_to book_path(@clipping.book)
  end

  def update
    ir = @clipping.instapaper_reference
    if ir
      ir.title = params[:instapaper_reference][:title]
      ir.url = params[:instapaper_reference][:url]
      ir.save
    end
    redirect_to book_path(@clipping.book)
  end

  def destroy
    @clipping.instapaper_reference.destroy
    redirect_to book_path(@clipping.book)
  end

  private
  def scope_to_clipping
    @clipping = Clipping.find(params[:clipping_id])
  end
end
