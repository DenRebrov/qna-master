require 'rails_helper'

feature '&&&&&' do
  given(:user) { create(:user) }
  given(:admin) { create(:user, admin: true) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Admin can see button "Ask question"' do
    sign_in(admin)
    expect(page).to have_content "Ask question"
  end

  scenario 'User can see button "Ask question"' do
    sign_in(user)
    expect(page).to have_content "Ask question"
  end

  scenario 'Guest can not see button "Ask question"' do
    visit root_path
    expect(page).to_not have_content "Ask question"
  end

  scenario 'Admin can see buttons "Like!", "Dislike..."' do
    sign_in(admin)
    visit question_path(question)

    within ".question_#{question.id}" do
      within '.question_votes' do
        expect(page).to have_link 'Like!'
        expect(page).to have_link 'Dislike...'
      end
    end
  end
end