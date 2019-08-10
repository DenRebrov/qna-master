require 'rails_helper'

feature 'Author can delete his question' do

  given(:author_user) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: author_user) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user' do
    scenario 'deletes his question' do
      sign_in(author_user)
      visit question_path(question)

      expect(page).to have_content question.body

      click_on 'Delete'

      expect(page).to have_content 'Your question succesfully deleted.'
      expect(page).to_not have_content question.body
    end

    scenario "deletes someone else's question" do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end

    scenario 'deletes file to his question' do
      sign_in(author_user)
      visit question_path(question)

      within '.files' do
        click_on 'X'
      end

      expect(page).to have_content 'Your file succesfully deleted.'
      expect(page).to_not have_content question.files
    end

    scenario 'deletes file to another question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'X'
    end

    scenario 'deletes link to his question' do
      sign_in(author_user)
      visit question_path(question)

      within '.links' do
        click_on 'X'
      end
        expect(page).to have_content 'Your link succesfully deleted.'
        expect(page).to_not have_content question.links
    end

    scenario 'deletes link to another question' do
      sign_in(user)
      visit question_path(question)

      within '.links' do
        expect(page).to_not have_link 'X'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to deletes a question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete'
    end
  end
end