require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('Service::NewAnswerNotification') }
  let(:question) { create :question }
  let(:subscriptions) { create_list :subscription, 2, question: question }
  let(:answer) { create :answer, question: question }

  before do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls Service::NewAnswerNotification#send_new_answer_notification' do
    expect(service).to receive(:send_new_answer_notification)
    NewAnswerNotificationJob.perform_now(answer)
  end
end
