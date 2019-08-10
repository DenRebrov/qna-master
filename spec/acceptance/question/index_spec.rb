require 'rails_helper'

feature 'User can see questions list' do

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  background do
    visit new_user_session_path
    sign_in(user)
  end

  scenario 'User see questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end