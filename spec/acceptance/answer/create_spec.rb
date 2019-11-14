require 'rails_helper'

feature 'User can write answer for the question', %q{
  The user, being on the question page, can write an answer to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write an answer', js: true do
      fill_in 'Body', with: 'Answer Body Text'
      click_on 'Create Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer Body Text'
      end
    end

    scenario 'write an answer with errors', js: true do
      click_on 'Create Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'write an answer with attached files', js: true do
      within '.answer-form' do
        fill_in 'Answer Body', with: 'Answer Body Text'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Create Answer'
      end

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Body'
    expect(page).to_not have_link 'Create Answer'
  end

  context 'multiple sessions' do
    scenario 'answer appears on another user\'s page', js: true do
      Capybara.using_session('another_user') do
        sign_in(another_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        fill_in 'Your answer', with: 'Answer'
        click_on 'Reply'

        expect(current_path).to eq question_path(question)
        within '.answers' do
          expect(page).to have_content 'Answer'
        end
      end

      Capybara.using_session('user') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to have_content 'Rating:'
          expect(page).to have_link 'Like!'
          expect(page).to have_link 'Dislike...'
          expect(page).to have_link 'Make the best'
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer'
          expect(page).to have_link 'Like!'
          expect(page).to have_link 'Dislike...'
        end
      end
    end
  end
end