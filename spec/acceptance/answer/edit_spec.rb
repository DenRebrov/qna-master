require 'rails_helper'

feature 'User can edit his answer' do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with invalid attributes', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your answer', with: ''
        click_on 'Save Answer'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edits his answer with attached files', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your answer', with: 'edited body'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save Answer'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with links', js: true do
      within '.answers' do
        click_on 'Edit Answer'
        fill_in 'Your answer', with: 'edited body'

        click_on 'Add link'
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save Answer'

        expect(page).to have_link 'My gist'
      end
    end
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit Answer'
    end
  end
end
