FactoryBot.define do
  factory :reward do
    title { "MyReward" }
    image { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    question
  end
end
