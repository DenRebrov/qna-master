require 'sphinx_helper'

feature 'Search' do
  given!(:user) { create(:user, email: 'search@test.com') }
  given!(:question) { create(:question, body: 'search') }
  given!(:answer) { create(:answer, body: 'search') }
  given!(:comment) { create(:comment, commentable: question, body: 'search') }

  scenario 'User search in Questions', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Question', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(question.title)
      end      
    end
  end

  scenario 'User search in Answers', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Answer', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(answer.body)
      end      
    end
  end

  scenario 'User search in Comments', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'Comment', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(comment.body)
      end      
    end
  end

  scenario 'User search in Users', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

      within '.search' do
        fill_in 'search_text', with: 'search*'
        select 'User', from: 'search_object'
        click_on 'Search'
      end

      within '.search_results' do
        expect(page).to have_content(user.email)
      end      
    end
  end

  scenario 'User search in all', sphinx: true, js: true do
    ThinkingSphinx::Test.run do
      visit questions_path

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
