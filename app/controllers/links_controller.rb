class LinksController < ApplicationController

  before_action :authenticate_user!, :only => [:new, :create, :upvote, :downvote]

  def show
    @link = Link.find_by(:id => params[:id]) || not_found!
    @comment = @link.comments.new(:link_id => @link.id)
    # session[:link_id] = @link.id
  end

  def index
    @links = Link.all.order("score DESC").page params[:page]
  end

  def newest
    @links = Link.all.order("created_at DESC").page params[:page]
    render "index"
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

  def upvote
    @link = Link.find_by(:id => params[:id]) || not_found!
    @link.liked_by current_user
    @link.update_score
    redirect_to :back
  end

  def downvote
    @link = Link.find_by(:id => params[:id]) || not_found!
    @link.disliked_by current_user
    @link.update_score
    redirect_to :back
  end

private

  def link_params
    params.require(:link).permit(:link_url, :title, :tag_list)
  end
end
