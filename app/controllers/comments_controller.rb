class CommentsController < ApplicationController
  before_action :authenticate_user!, :only => [:create]

  def create
    @link = Link.find_by(:id => session[:link_id])
    @comment  = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.link_id = @link.id
    session.delete(:link_id)

    if @comment.save
      redirect_to link_url(@link.id), :notice => "Comment added"
    else
      redirect_to link_url(@link.id)
    end
  end

private

  def comment_params
    params.require(:comment).permit(:text)
  end
end
