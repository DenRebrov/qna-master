require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_file, user: user) }
  let(:answer) { create(:answer, :with_file, question: question, user: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:authored_question) { create(:question, :with_file, user: user) }
    let!(:authored_answer) { create(:answer, :with_file, question: question, user: user) }
    let(:file) { authored_question.files.first }
    let(:answer_file) { authored_answer.files.first }

    context 'User tries to delete file on his resource' do
      it 'deletes the file on his question' do
        expect { delete :destroy, params: { id: file.id } }.to change(authored_question.files, :count).by(-1)
      end

      it 'deletes the file on his answer' do
        expect { delete :destroy, params: { id: answer_file.id } }.to change(authored_answer.files, :count).by(-1)
      end
    end

    context 'User tries to delete file to another resource' do
      before { sign_in(create(:user)) }
      before { question }
      before { answer }

      let(:file) { question.files.first }

      it 'does not delete file on another question' do
        expect { delete :destroy, params: { id: file.id } }.to_not change(question.files, :count)
      end

      it 'does not delete file on another answer' do
        expect { delete :destroy, params: { id: file.id } }.to_not change(answer.files, :count)
      end
    end
  end
end
