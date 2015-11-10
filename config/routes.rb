Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root   'jobs#index'

  # For the load balancer
  get 'health_check' => 'health_check#index', :as => :health_check
  
  # We don't do a lot of resource routing here because we want the
  # URLs to be as SEO friendly as possible. :-/
  #
  get    '/job/:id'                                  => 'jobs#show',  as: :job
  get    '/jobs/'                                    => 'jobs#index', as: :jobs
  get    '/jobs/new'                                 => 'jobs#new'
  get    '/jobs/:tags'                               => 'jobs#index', as: :tag
  post   '/jobs'                                     => 'jobs#create'

  post   '/alerts'                                   => 'alerts#create'
  delete '/alerts/:id'                               => 'alerts#destroy', as: :alert
  get    '/alerts/new'                               => 'alerts#new'
  get    '/alerts/tags/:tags/new'                    => 'alerts#new'

  get    '/unsubscribe/:token'                       => 'email_addresses#unsubscribe', as: :unsubscribe

  resources :email_addresses do
    get :validate # REST be damned. Email clients can't do POSTs. :(
  end
  resources :filter_tags
  resources :users
  resource  :session
  resources :password_resets
end
