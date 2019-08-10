require 'rails_helper'

feature 'User can sign up' do
  given(:user) { create(:user) }

  scenario 'Unregistered user tries to sign up' do
    sign_up(user)

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    visit new_user_registration_path
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@mail.ru'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '11'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end

