class InstapaperReferencesController < ApplicationController
  before_filter :scope_to_clipping

  def update
    ir = @clipping.instapaper_reference
    if ir
      ir.title = params[:title]
      ir.url = params[:url]
      ir.save
    end
    redirect_to book_path(@clipping.book)
  end

  def destroy
    @clipping.instapaper_reference.destroy
  end

  def find
    ir = InstapaperReference.find_or_create_from_clipping(@clipping)

    # just sticking this in for debug.
    #ir = InstapaperReference.create(:title => "test", :url => "http://example.com", :clipping => @clipping)
    render :text => ir.to_json if ir
  end
  private
  def scope_to_clipping
    @clipping = Clipping.find(params[:clipping_id])
  end
end
