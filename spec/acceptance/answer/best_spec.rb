require 'rails_helper'

feature 'Question author may choose the best answer for your question' do
  given(:author_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, :with_reward, user: author_user) }
  given!(:answer) { create(:answer, question: question, user: author_user) }
  # given!(:reward) { create(:reward, question: question) }

  scenario 'Question author may choose the best answer for your question', js: true do
    sign_in(author_user)
    visit question_path(question)

    within '.answers' do
      click_on 'Make the best'

      expect(page).to have_content '(BEST Answer)'
    end
  end

  scenario 'Authorized User must see awards received', js: true do
    sign_in(author_user)
    visit question_path(question)

    within '.answers' do
      click_on 'Make the best'
    end

    visit rewards_path
    expect(page).to have_content 'MyReward'
  end

  scenario 'Aythenticated user tries to choose the best answer for another question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Make the best'
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer for question' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Make the best'
    end
  end
end