class CommentsController < ApplicationController
  before_action :require_user
  def create
    @recipe = Recipe.find(params[:recipe_id])
    @comment = @recipe.comments.build(comments_params)
    @comment.chef = current_chef
    if @comment.save
      ActionCable.server.broadcast "comments", render(partial: 'comments/comment', object: @comment)
    else
      flash[:danger] = "Comment wasn't created"
      redirect_back(fallback_location: recipe_path(@recipe))
    end
  end

  private

  def comments_params
    params.require(:comment).permit(:description)
  end
end
