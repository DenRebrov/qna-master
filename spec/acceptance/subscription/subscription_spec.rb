require 'rails_helper'

feature 'Subscriptions' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)

      click_on 'Subscribe to the question'
    end

    scenario 'subscribes to a question', js: true do
      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'Subscribe to the question'
      expect(page).to have_link 'Unsubscribe from the question'
    end

    scenario 'unsubscribes from question', js: true do
      click_on 'Unsubscribe from the question'

      expect(current_path).to eq question_path(question)
      expect(page).to_not have_link 'Unsubscribe from the question'
      expect(page).to have_link 'Subscribe to the question'
    end
  end

  context 'Non-subscribed user' do
    given(:another_user) { create(:user) }
    given!(:subscription) { create(:subscription, user: user, question: question) }

    scenario 'does not sees unsubscribe link' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).to have_link 'Subscribe to the question'
      expect(page).to_not have_link 'Unsubscribe from the question'
    end
  end

  context 'Non-authenticated' do
    it 'does not sees subscribes links' do
      visit question_path(question)

      within('.question') do
        expect(page).to_not have_link 'Subscribe to the question'
        expect(page).to_not have_link 'Unsubscribe from the question'
      end
    end
  end
end