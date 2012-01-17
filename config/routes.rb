Locomotive::Engine.routes.draw do

  # authentication
  devise_for :locomotive_account,
    :class_name   => 'Locomotive::Account',
    :path         => '',
    :path_prefix  => nil,
    :failure_app  => 'Locomotive::Devise::FailureApp',
    :controllers  => { :sessions => 'locomotive/sessions', :passwords => 'locomotive/passwords' } do
      match '/' => 'sessions#new'
  end

  root :to => 'pages#index'

  resources :pages do
    put :sort, :on => :member
    get :get_path, :on => :collection
  end

  resources :snippets

  resources :sites

  resource :current_site, :controller => 'current_site'

  resources :accounts

  resource :my_account, :controller => 'my_account'

  resources :memberships

  resources :theme_assets do
    get :all, :action => 'index', :on => :collection, :defaults => { :all => true }
  end

  resources :content_assets

  resources :content_types

  resources :content_entries, :path => 'content_types/:slug/entries' do
    put :sort, :on => :collection
  end

  resources :custom_fields, :path => 'custom/:parent/:slug/fields'

  resources :cross_domain_sessions, :only => [:new, :create]

  resource :import, :only => [:new, :show, :create], :controller => 'import'

  resource :export, :only => [:new], :controller => 'export'

  # installation guide
  match '/installation'       => 'installation#show', :defaults => { :step => 1 }, :as => :installation
  match '/installation/:step' => 'installation#show', :as => :installation_step
end

Rails.application.routes.draw do
  # sitemap
  match '/sitemap.xml'  => 'locomotive/public/sitemaps#show', :format => 'xml'

  # robots.txt
  match '/robots.txt'   => 'locomotive/public/robots#show', :format => 'txt'

  # public content entry submissions
  resources :locomotive_entry_submissions, :controller => 'locomotive/public/content_entries', :path => 'entry_submissions/:slug'

  # magic urls
  match '/_admin'       => 'locomotive/public/pages#show_toolbar'
  match '*path/_admin'  => 'locomotive/public/pages#show_toolbar'

  match '/_edit'        => 'locomotive/public/pages#edit'
  match '*path/_edit'   => 'locomotive/public/pages#edit'

  match '/'             => 'locomotive/public/pages#show'
  match '*path'         => 'locomotive/public/pages#show'
end