require 'sphinx_helper'

feature 'Search' do

  scenario 'User searches for the answer', sphinx: true, js: true do
    visit questions_path

    ThinkingSphinx::Test.run do
      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'All', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.title)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
      end      
    end
  end
end
