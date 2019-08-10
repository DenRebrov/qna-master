FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :with_reward do
      reward { create(:reward) }
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      title { nil }
    end
  end
end
