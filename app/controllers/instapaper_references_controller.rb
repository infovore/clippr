class InstapaperReferencesController < ApplicationController
  before_filter :scope_to_clipping

  def find
    ir = InstapaperReference.find_or_create_from_clipping(@clipping)
    render :text => ir.to_json if ir
  end
  private
  def scope_to_clipping
    @clipping = Clipping.find(params[:clipping_id])
  end
end
