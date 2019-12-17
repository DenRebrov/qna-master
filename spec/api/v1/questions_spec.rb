require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) {{"CONTENT_TYPE" => "application/json",
                  "ACCEPT" => 'application/json'}}

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) {create(:access_token)}
      let(:user) {create(:user)}
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question , user: user) }

      before {get api_path, params: {access_token: access_token.token}, headers: headers}

      it_behaves_like "API Successful request"

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /show' do
    it_behaves_like "API Authorizable"

    context 'authorized' do
      let!(:comment) { create :comment, commentable: question }
      let!(:attachment) { create :attachment, attachable: question }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "API Successful request"

      it 'returns all public fields' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("question/short_title")
      end

      context 'answers' do
        subject { answer }
        it_behaves_like "API Included objects", 'included in question object', 1, 'question/answers'
        it_behaves_like "API Contains attributes", 'answer', 'question/answers/0/'
      end

      context 'comments' do
        it 'included in object' do
          expect(response.body).to have_json_size(1).at_path("#{type}/comments")
        end

        subject { comment }

        it 'returns all public fields' do
          %w[id user_id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
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
        let(:post_object) { do_request(question: attributes_for(:question), access_token: access_token.token) }

        it 'returns 201 status code' do
          post_object
          expect(response).to be_successful
        end

        it "saves a new user's #{Question.to_s.downcase} in the database" do
          expect { post_object }.to change(user.send(Question.to_s.downcase.pluralize.to_sym), :count).by(1)
        end
      end

      context 'with invalid attributes' do
        let(:post_invalid_object) { do_request(question: attributes_for(:invalid_question), access_token: access_token.token) }

        it 'returns 422 status code' do
          post_invalid_object
          expect(response.status).to eq 422
        end

        it "does not save the #{Question.to_s.downcase}" do
          expect { post_invalid_object }.to_not change(Question, :count)
        end
      end
    end
  end
end