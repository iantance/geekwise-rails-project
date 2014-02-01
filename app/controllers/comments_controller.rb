class CommentsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    @link = Link.find_by(:id => session[:link_id])
    @comment  = current_user.comments.new(comment_params)
    @comment.link_id = @link.id

    if @comment.save
      redirect_to link_url(@link.id), :notice => "Comment added"
    else
      render "links/show"
    end
  end

private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
