require 'rails_helper'

feature 'Vote for answer' do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(answer.question)
    end

    scenario 'tries to like not his answer', js: true do
      within ".answer_#{answer.id}" do
        within '.answer_votes' do
          click_on 'Like!'

          within ".answer_rating_#{answer.id}" do
            expect(page).to have_content answer.rating
          end
        end
      end
    end

    scenario 'tries to dislike not his answer', js: true do
      within ".answer_#{answer.id}" do
        within '.answer_votes' do
          click_on 'Dislike...'

          within ".answer_rating_#{answer.id}" do
            expect(page).to have_content answer.rating
          end
        end
      end
    end
  end

  scenario 'Author of answer does not see the voting links' do
    visit question_path(answer.question)

    within ".answer_#{answer.id}" do
      within '.answer_votes' do
        expect(page).to_not have_link 'Like!'
        expect(page).to_not have_link 'Dislike...'
      end
    end
  end

  scenario 'Non-authenticated user does not see the voting links' do
    visit question_path(answer.question)

    within ".answer_#{answer.id}" do
      within '.answer_votes' do
        expect(page).to_not have_link 'Like!'
        expect(page).to_not have_link 'Dislike...'
      end
    end
  end
end