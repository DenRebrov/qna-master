require 'rails_helper'

RSpec.describe Services::NewAnswerNotification do
  let(:question) { create :question }
  let(:subscriptions) { create_list :subscription, 2, question: question }
  let(:answer) { create :answer, question: question }

  it 'sends new answer notification from author for question' do
    question.subscriptions.each do |subscription|
      expect(NewAnswerMailer).to receive(:new_answer).with(subscription.user, answer).and_call_original
    end
  end
end