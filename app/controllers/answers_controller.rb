class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[show edit update destroy best like dislike]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  def best
    @question = @answer.question
    @answer.set_best
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url], rewards_attributes: [:title, :image])
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answers_question_#{@question.id}",
        answer: @answer,
        links: @answer.links,
        rating: @answer.rating
    )
  end
end
