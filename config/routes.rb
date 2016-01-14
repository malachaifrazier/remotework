
class DomainConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include? request.domain
  end
end

Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |username, password|
    username == ENV["SIDEKIQ_USERNAME"] && password == ENV["SIDEKIQ_PASSWORD"]
  end if Rails.env.production?
  mount Sidekiq::Web => '/sidekiq'

  constraints DomainConstraint.new(['rawsme.local', 'raws.me']) do
    get "/:id" => "shortened_links#show"
  end

  root   'jobs#index'

  # For the load balancer
  get 'health_check'                      => 'health_check#index', :as => :health_check

  resources :jobs do
    member do
      get   :preview
      post  :post
      patch :pause
    end
  end
  get    '/tags/:tags'                    => 'jobs#index',     as: :tag

  post   '/alerts'                        => 'alerts#create'
  delete '/alerts/:id'                    => 'alerts#destroy', as: :alert
  get    '/alerts/new'                    => 'alerts#new'
  get    '/alerts/tags/:tags/new'         => 'alerts#new'

  get    '/unsubscribe/:token'            => 'email_addresses#unsubscribe', as: :unsubscribe

  get    '/about'                         => 'pages#about', as: :about
  get    '/why'                           => 'pages#why', as: :why

  resources :email_addresses do
    get :validate
  end
  resources :filter_tags
  resources :users
  resource  :session
  resources :password_resets
  resources :validations

  namespace :admin do
    resources :jobs
  end
end
