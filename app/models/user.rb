class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(resource)
    self.id == resource.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authorization(auth)
    else
      password = Devise.friendly_token[0, 20]

      if auth.info[:provider] == 'github'
        user = User.create!(email: email, password: password, password_confirmation: password)
      else
        user = User.create!(email: 'den_rebrov@mail.ru', password: password, password_confirmation: password)
      end
      user.create_authorization(auth)
    end

    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
