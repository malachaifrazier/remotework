Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'jobs#index'

  get '/jobs/'                              => 'jobs#index', as: :jobs
  get '/jobs/:id'                           => 'jobs#show',  as: :job
  get '/jobs/tags/:tags'                    => 'jobs#index', as: :tag
  get '/jobs/category/:category'            => 'jobs#index', as: :category
  get '/jobs/category/:category/tags/:tags' => 'jobs#index', as: :category_tag
end
