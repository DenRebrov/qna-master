class DailyDigestMailer < ApplicationMailer

  def digest(user)
    @questions = Question.for_the_last_day

    mail to: user.email
  end
end
