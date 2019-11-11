class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_resource, only: :create
  before_action :find_comment, only: %i[update destroy]
  after_action :publish_comment, only: :create

  authorize_resource

  def create
    @comment = @resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  def update
    @comment.update(comment_params) if current_user.author_of?(@comment)
  end

  def destroy
    @comment.destroy if current_user.author_of?(@comment)
  end

  private

  def find_resource
    if params[:answer_id]
      @resource = Answer.find(params[:answer_id])
    else
      @resource = Question.find(params[:question_id])
    end
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast("comments_question_#{question_id}", comment: @comment)
  end
end
