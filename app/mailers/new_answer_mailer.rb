class NewAnswerMailer < ApplicationMailer

  def new_answer(user, answer)
    @question = answer.question

    mail to: user.email
  end
end