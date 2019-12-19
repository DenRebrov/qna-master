class Api::V1::AnswersController < Api::V1::BaseController
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:show, :edit, :update, :destroy]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def edit; end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner
    @answer.save
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end