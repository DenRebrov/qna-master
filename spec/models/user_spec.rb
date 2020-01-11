require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:rewards) }
  it { should have_many(:votes) }
  it { should have_many(:comments) }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'def author_of?' do
    let(:user) { create(:user) }
    let(:author_user) { create(:user) }
    let(:question) { create(:question, user: author_user) }

    it 'Returns true if question belongs to user' do
      expect(author_user).to be_author_of(question)
    end

    it 'Returns false if question does not belongs to user' do
      expect(user).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '#subscribed?' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }
    let!(:subscription) { create(:subscription, user: user)}

    it 'Returns true if user subscribed to question' do
      expect(user).to be_subscribed(subscription.question)
    end

    it 'Returns false if user not subscribed to question' do
      expect(another_user).to_not be_subscribed(subscription.question)
    end
  end
end