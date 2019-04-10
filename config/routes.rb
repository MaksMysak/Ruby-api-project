Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :sessions, only: %i[create destroy]
      resources :users, only: [:create] do
        collection do
          get :my_profile
          post :social_network
        end
      end
      # get 'page/index'
      # root 'page#index'
    end
  end
end
