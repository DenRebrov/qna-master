require 'rails_helper'

feature 'Add comment to question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'creates comment for question with valid attributes', js: true do
      within '.question_comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: 'New comment'
        click_on 'Comment'
        expect(page).to have_content 'New comment'
      end
    end

    scenario 'creates comment for question with invalid attributes', js: true do
      within '.question_comments' do
        click_on 'Add comment'
        fill_in 'Comment', with: ''
        click_on 'Comment'
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
  end

  scenario 'Non-authenticated user tries to create comment for question' do
    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Add comment'
    end
  end

  context 'multiple sessions' do
    scenario 'comment appears on another user\'s page', js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question_comments' do
          click_on 'Add comment'
          fill_in 'Comment', with: 'New comment'
          click_on 'Comment'
          expect(page).to have_content 'New comment'
        end
      end

      Capybara.using_session('guest') do
        within '.question_comments' do
          expect(page).to have_content 'New comment'
        end
      end
    end
  end
end