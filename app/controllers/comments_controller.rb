class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice] = "Comment has been successfully created."
      redirect_to post_path(@post)
    else
      flash[:notice] = "Comment has not been created."
      redirect_to post_path(@post)
    end
  end

  # def update
  #   @comment = @post.comments.find(params[:id])
  #   @comment.update(comment_params)
  #   redirect_to post_path
  # end

  # def update
  #   @comment = @post.comments.find(params[:id])
  #
  #   respond_to do |format|
  #     if @comment.update(comment_params)
  #       format.html { redirect_to post_url(@post), notice: "Comment has updated successfully."}
  #     end
  #     format.html { redirect_to post_url(@post), notice: "Comment was not updated."}
  #   end
  # end

  def destroy
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:notice] = "Comment has been deleted sucessfully."
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
