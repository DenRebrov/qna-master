require 'rails_helper'

feature 'Delete comment' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:comment) { create(:comment, commentable: question, user: user) }

  scenario 'Authenticated user tries to delete his comment', js: true do
    sign_in(user)

    visit question_path(question)

    within '.question_comments' do
      click_on 'Delete'
    end

    expect(page).to_not have_content comment.body
  end

  scenario 'Authenticated user tries to delete not his comment' do
    sign_in(another_user)

    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Delete'
    end
  end

  scenario 'Non-authenticated user tries to delete comment' do
    visit question_path(question)

    within '.question_comments' do
      expect(page).to_not have_link 'Delete'
    end
  end
end