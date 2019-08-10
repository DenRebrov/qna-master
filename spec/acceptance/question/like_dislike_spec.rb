require 'rails_helper'

feature 'Vote for answer' do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to like not his question', js: true do
      within ".question_#{question.id}" do
        within '.question_votes' do
          click_on 'Like!'

          within '.question_rating' do
            expect(page).to have_content question.rating
          end
        end
      end
    end

    scenario 'tries to dislike not his question', js: true do
      within ".question_#{question.id}" do
        within '.question_votes' do
          click_on 'Dislike...'

          within '.question_rating' do
            expect(page).to have_content question.rating
          end
        end
      end
    end
  end

  scenario 'Author of question does not see the voting links' do
    visit question_path(question)

    within ".question_#{question.id}" do
      within '.question_votes' do
        expect(page).to_not have_link 'Like!'
        expect(page).to_not have_link 'Dislike...'
      end
    end
  end

  scenario 'Non-authenticated user does not see the voting links' do
    visit question_path(question)

    within ".question_#{question.id}" do
      within '.question_votes' do
        expect(page).to_not have_link 'Like!'
        expect(page).to_not have_link 'Dislike...'
      end
    end
  end
end