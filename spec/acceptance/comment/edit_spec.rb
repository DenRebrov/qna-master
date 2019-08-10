require 'rails_helper'

feature 'Comment editing' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  scenario 'Unauthenticated user try to edit comment' do
    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Author' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.question_comments' do
        expect(page).to have_link 'Edit'
      end
    end

    scenario 'try to edit his comment', js: true do
      within '.question_comments' do
        click_on 'Edit'
        fill_in 'Comment', with: 'Edited comment'
        click_on 'Save'
        expect(page).to_not have_content comment.body
        expect(page).to have_content 'Edited comment'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'Authenticated user try to edit other user\'s comment' do
    sign_in(another_user)

    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Edit'
    end
  end
end