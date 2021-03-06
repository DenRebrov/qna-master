require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_one(:reward) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_length_of(:title).is_at_most(30) }
  it { should validate_length_of(:body).is_at_most(255) }

  it { should accept_nested_attributes_for :links }

  it 'have many attaced files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:user) { create(:user) }
    let(:question) { build(:question, user: user) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
