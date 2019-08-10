module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def add_like
    if votes.where(value: -1, user: user).present?
      votes.where(value: -1, user: user).delete_all
    else
      votes.find_or_create_by!(value: 1, user: user)
    end
  end

  def add_dislike
    if votes.where(value: 1, user: user).present?
      votes.where(value: 1, user: user).delete_all
    else
      votes.find_or_create_by!(value: -1, user: user)
    end
  end

  def rating
    votes.sum(:value)
  end
end