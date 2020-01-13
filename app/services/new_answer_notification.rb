class Services::NewAnswerNotification
  def send_new_answer_notification
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      NewAnswerMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end