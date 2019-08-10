class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  # def call
  #   authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
  #   return authorization.user if authorization
  #
  #   email = auth.info[:email]
  #   user = User.where(email: email).first
  #   if user
  #     user.create_authorization(auth)
  #   else
  #     password = Devise.friendly_token[0, 20]
  #
  #     if auth.info[:provider] == 'github'
  #       user = User.create!(email: email, password: password, password_confirmation: password)
  #     else
  #       user = User.create!(email: 'den_rebrov@mail.ru', password: password, password_confirmation: password)
  #     end
  #     user.create_authorization(auth)
  #   end
  #
  #   user
  # end
end
