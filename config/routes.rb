Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root   'jobs#index'

  get    '/jobs/'                                    => 'jobs#index', as: :jobs
  get    '/jobs/:id'                                 => 'jobs#show',  as: :job
  get    '/jobs/tags/:tags'                          => 'jobs#index', as: :tag

  post   '/alerts'                                   => 'alerts#create'
  delete '/alerts/:id'                               => 'alerts#destroy', as: :alert
  get    '/alerts/new'                               => 'alerts#new'
  get    '/alerts/tags/:tags/new'                    => 'alerts#new'
  get    '/alerts/category/:category/new'            => 'alerts#new'
  get    '/alerts/category/:category/tags/:tags/new' => 'alerts#new'

  get    '/unsubscribe/:token'                       => 'email_addresses#unsubscribe', as: :unsubscribe

  resources :email_addresses do
    get :validate # REST be damned. Email clients can't do POSTs. :(
  end
  resources :filter_tags
end
