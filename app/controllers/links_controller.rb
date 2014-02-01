class LinksController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create]

  def show
    @link = Link.find_by(params[:id]) || not_found!
    @comment = @link.comments.new
    session[:link_id] = @link.id
  end

  def index
    @links = Link.all.order("created_at DESC")  
  end
  
  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.new(link_params)

    if @link.save
      redirect_to links_url, :notice => "Link Added"
    else
      render("new")
    end
  end


private

  def link_params
    params.require(:link).permit(:link_url, :title)
  end
end
