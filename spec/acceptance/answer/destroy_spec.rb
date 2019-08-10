require 'rails_helper'

feature 'Author can delete his answer' do

  given(:author_user) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author_user) }
  given!(:answer) { create(:answer, :with_file, question: question, user: author_user) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user' do
    scenario 'deletes his answer', js: true do
      sign_in(author_user)
      visit question_path(question)

      expect(page).to have_content answer.body

      within '.answers' do
        click_on 'Delete Answer'
      end

      expect(page).to_not have_content answer.body
    end

    scenario "deletes someone else's answer", js: true do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete Answer'
    end

    scenario 'deletes file to his answer' do
      sign_in(author_user)
      visit question_path(question)

      within '.answer_files' do
        click_on 'X'
      end

      expect(page).to have_content 'Your file succesfully deleted.'
      expect(page).to_not have_content answer.files
    end

    scenario 'deletes file to another answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'X'
    end

    scenario 'deletes link to his answer' do
      sign_in(author_user)
      visit question_path(question)

      within '.answer_links' do
        click_on 'X'
      end
      expect(page).to have_content 'Your link succesfully deleted.'
      expect(page).to_not have_content question.links
    end

    scenario 'deletes link to another answer' do
      sign_in(user)
      visit question_path(question)

      within '.answer_links' do
        expect(page).to_not have_link 'X'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to deletes an answer', js: true do
      visit question_path(question)

      expect(page).to_not have_link 'Delete Answer'
    end
  end
end