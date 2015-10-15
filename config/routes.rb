Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'jobs#index'

  resources :jobs do
    collection do
      resources :tags
    end
    collection do
      resources :categories do
        resources :tags
      end
    end
  end
end
