class User < ApplicationRecord
  devise :database_authenticatable, :registerable, #:confirmable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author_of?(resource)
    self.id == resource.user_id
  end

  def subscribed?(question)
    result = nil

    self.subscriptions.find_each do |subscription|
      subscription.question == question ? result = true : result = false
    end
    result
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
