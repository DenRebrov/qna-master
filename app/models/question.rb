class Question < ApplicationRecord
  include Linkable
  include Votable
  include Commentable

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true, length: { maximum: 30 }
  validates :body, length: { maximum: 255 }

  after_create :calculate_reputation

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
