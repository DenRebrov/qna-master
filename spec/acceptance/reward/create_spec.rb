require 'rails_helper'

feature 'User can create reward for best answer' do
  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Author can add reward while creating question' do
    visit new_question_path
    within '.question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end
    within '.reward' do
      fill_in 'Title', with: 'Reward question'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask'

    expect(page).to have_content 'Your question succesfully created.'
  end
end