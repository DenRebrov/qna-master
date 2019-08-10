FactoryBot.define do
  factory :comment do
    user
    commentable
    sequence(:body) { |n| "CommentBody#{n}" }
  end

  factory :invalid_comment, class: "Comment" do
    user
    body
  end
end