require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, :with_reward, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { sign_in(user) }

    context 'with valid attributes' do
      it "saves a new user\'s answer in the database" do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(user.answers, :count).by(1)
      end

      it "saves a new user\'s question in the database" do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #like' do
    before { sign_in(another_user) }

    it 'saves a new vote in the database' do
      expect { post :like, params: { id: answer.id, format: :json } }.to change(answer.votes, :count).by(1)
    end
  end

  describe 'POST #dislike' do
    before { sign_in(another_user) }

    it 'saves a new vote in the database' do
      expect { post :like, params: { id: answer.id, format: :json } }.to change(answer.votes, :count).by(1)
    end
  end

  describe 'PATCH #update' do
    before { sign_in(user) }

    context 'User update his answer with valid attributes' do
      it 'changes anwser attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User tries to update his answer with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'User tries to update not his answer' do
      before { sign_in(another_user) }

      it 'does not change answer attributes' do
        old_body = answer.body
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq old_body
      end
    end
  end

  describe 'PATCH #best' do
    context 'User set best answer to his question' do
      before { sign_in(user) }

      it 'choose the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end

      it 'assigns reward to user' do
        expect { patch :best, params: {id: answer}, format: :js }.to change(answer.user.rewards, :count).by(1)
      end
    end

    context 'User set best answer to another question' do
      before { sign_in(create(:user)) }

      it 'does not chooses the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).not_to be_best
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    let!(:authored_answer) { create(:answer, question: question, user: user) }

    context 'User tries to delete his answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: authored_answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: authored_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his answer' do
      before { sign_in(another_user) }

      it 'does not delete question' do
        expect { delete :destroy, params: { id: authored_answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'render destroy template' do
        delete :destroy, params: { id: authored_answer, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
