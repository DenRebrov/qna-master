require 'rails_helper'

feature 'Sign in with social networks accounts' do

  OmniAuth.config.test_mode = true

  scenario 'can sign in user with GitHub account' do
    visit new_user_session_path

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
        provider: 'github',
        uid: '123456',
        info: { email: 'den@rebrov.ru' }
    )

    click_on 'Sign in with GitHub'

    expect(page).to have_content 'Successfully authenticated from GitHub account.'
    expect(page).to have_content 'den@rebrov.ru'
  end

  scenario 'can sign in user with Vkontakte account' do
    visit new_user_session_path

    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
        provider: 'vkontakte',
        uid: '123456',
        info: { email: 'den@rebrov.ru' }
    )

    click_on 'Sign in with Vkontakte'

    expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    expect(page).to have_content 'den@rebrov.ru'
  end
end