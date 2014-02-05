class CommentsController < ApplicationController
  before_action :authenticate_user!, :only => [:create, :upvote, :downvote]

  def show
    @comment = Comment.find_by(:id => params[:id]) || not_found!
    @new_nested_comment = Comment.new(:parent_id => @comment.id, :link_id => @comment.link_id)
  end

  def create
    @comment  = Comment.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      if @comment.parent_id
        redirect_to comment_url(@comment.parent_id), :notice => "Comment added"
      else
        redirect_to link_url(@comment.link_id), :notice => "Comment added"
      end
    else
      if @comment.parent_id
        redirect_to comment_url(@comment.parent_id)
      else
        redirect_to link_url(@comment.link_id)
      end
    end
  end

  def upvote
    @comment = Comment.find_by(:id => params[:id]) || not_found!
    @comment.liked_by current_user
    @comment.update_score
    redirect_to :back
  end

  def downvote
    @comment = Comment.find_by(:id => params[:id]) || not_found!
    @comment.disliked_by current_user
    @comment.update_score
    redirect_to :back
  end

private

  def comment_params
    params.require(:comment).permit(:text, :link_id, :parent_id)
  end
end
