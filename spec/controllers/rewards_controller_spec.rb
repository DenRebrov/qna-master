require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:question_reward) { create(:reward, question: question) }
  let(:user_reward) { create(:reward, user: user) }

  describe 'GET #index' do
    before { sign_in(user) }
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end
