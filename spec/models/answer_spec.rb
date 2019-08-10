require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(255) }

  it { should accept_nested_attributes_for :links }

  it 'have many attaced files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#set_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, :with_reward, user: user) }
    let(:another_question) { create(:question, :with_reward, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:another_answer) { create(:answer, question: question, user: user) }
    let(:random_answer) { create(:answer, question: another_question, user: user) }

    before { answer.set_best }

    it 'should choose answer as the best' do
      expect(answer).to be_best
    end

    it 'should flag is not removed to best answer if it is an answer to another question' do
      random_answer.set_best
      answer.reload
      expect(answer).to be_best
      expect(random_answer).to be_best
    end

    it 'should change the best answer' do
      another_answer.set_best
      answer.reload
      expect(answer).to_not be_best
      expect(another_answer).to be_best
    end

    it 'should reward must belong to the user' do
      user.rewards.each do |reward|
        expect(reward.user_id).to eq user.id
      end
    end
  end
end
