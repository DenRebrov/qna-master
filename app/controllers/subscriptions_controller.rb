class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @question = Question.find(params[:question_id])

    @subscription = Subscription.new(user: current_user, question: @question)
    @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
  end
end
