class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true, optional: true, touch: true

  validates :body, presence: true
end
