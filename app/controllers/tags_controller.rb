class TagsController < ApplicationController
  def show
    @tag = Tag.find_by(name: params[:id])
    @events = @tag.events.paginate(page: params[:page], per_page: 8)
  end
end
