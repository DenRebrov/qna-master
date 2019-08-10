FactoryBot.define do
  factory :answer do
    body { "MyTextAnswer" }
    question { nil }

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :invalid do
      body { nil }
    end
  end
end
