require 'rails_helper'

describe 'Answers API' do
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 2, question: question) }
  let!(:answer) { answers.first }
  subject { answer }
  let!(:type) { answer.class.name.downcase }

  describe 'GET /index' do
    it_behaves_like "API Authorizable"

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"

      it "returns list of answers" do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      it 'returns all public fields' do
        %w[id best body created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authorizable"

    context 'authorized' do
      let!(:comment) { create :comment, commentable: answer }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"

      it 'returns all public fields' do
        %w[id best body created_at updated_at].each do |attr|
          expect(json[attr]).to eq me.send(attr).as_json
        end
      end

      context 'comments' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("#{type}/comments")
        end

        subject { comment }

        it 'returns all public fields' do
          %w[id user_id body created_at updated_at].each do |attr|
            expect(json[attr]).to eq me.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /create' do
    it_behaves_like "API Authorizable"

    context 'authorized' do
      let(:user) { User.find(access_token.resource_owner_id) }

      context 'with valid attributes' do
        let(:post_object) { do_request(answer: attributes_for(:answer), access_token: access_token.token) }

        it 'returns 201 status code' do
          post_object
          expect(response).to be_successful
        end

        it "saves a new user's #{Answer.to_s.downcase} in the database" do
          expect { post_object }.to change(user.send(Answer.to_s.downcase.pluralize.to_sym), :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:post_invalid_object) { do_request(answer: attributes_for(:invalid_answer), access_token: access_token.token) }

        it 'returns 422 status code' do
          post_invalid_object
          expect(response.status).to eq 422
        end

        it "does not save the #{Answer.to_s.downcase}" do
          expect { post_invalid_object }.to_not change(Answer, :count)
        end
      end
    end
  end
end