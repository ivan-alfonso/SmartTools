Rails.application.routes.draw do
  devise_for :users
  resources :competitions do
  	#resources :videos, only: [:create]
  	resources :videos
  end

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
