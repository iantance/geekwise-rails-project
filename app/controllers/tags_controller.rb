class TagsController < ApplicationController
  def show
    if @tag = Tag.find_by(:tag => params[:tag])
      @links = @tag.links.page params[:page]
      render "links/index"
    else
      flash[:notice] = "No links with tag: #{params[:tag]}"
      redirect_to links_url
    end
  end
end
