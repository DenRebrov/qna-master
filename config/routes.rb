Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: 'questions#index'

  concern :votable do
    member do
      post :like
      post :dislike
    end
  end

  resources :rewards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  concern :commentable do
    resources :comments, only: [:create, :update, :destroy], shallow: true
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable] do
      member do
        patch :best
      end
    end
  end

  mount ActionCable.server => '/cable'
end