class Answer < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, presence: true, length: { maximum: 255 }

  after_save :deliver_new_answer_notification
  # after_save :dsgsgd

  def set_best
    best_answer = question.answers.find_by(best: true)

    transaction do
      best_answer.update!(best: false) if best_answer
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end

  def deliver_new_answer_notification
    NewAnswerNotificationJob.perform_later(self)
  end

  # def dsgsgd
  #   Subscription.create(user: answer.question.user, question: answer.question)
  # end
end
