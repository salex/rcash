Rails.application.routes.draw do
  get 'welcome/home'
  get 'welcome/about'
  get 'welcome/test'
  resources :bank_statements do
    member do
      get :reconcile
      get :update_reconcile
    end
    collection do
      # get :last
      get :clear_splits
      get :unclear_splits
    end
  end

  resources :entries do
    member do
      get :duplicate
      patch :void
    end
    collection do
      get :search
      get :entry_search
    end
  end
  resources :accounts do
    member do
      post :set_recent
      get :set_recent

      get :list
      get :register_pdf
      get :split_register_pdf
    end
    collection do
      get :index_table
    end
  end
  
  resources :books do
    member do
      get :open
    end
  end

  resources :reports, only: :index do
    collection do
      get :profit_loss
      get :trial_balance
      get :checking_balance
      get :register_pdf
      get :split_register_pdf
      get :test
      get :clear_splits
      patch :clear_splits
      get :unclear_splits
      patch :unclear_splits
      get :summary
      get :trustee_audit
      get :custom
      get :audit
      get :edit_config
      patch :update_config


    end
  end

  resources :ofxes , only: [:index,:show,:edit,:update, :new] do
    member do
      get :link
      get :new_entry
      get :search
      patch :search
    end
    collection do
      get :latest
    end
  end

  resources :deposits do
    member do
      get :edit_other
      patch :update_other
    end
    collection do
      get :weekly
      get :month_summary
    end
  end

  resources :users  do
    collection do
      post :signin
    end
    member do
      patch :update_profile
      patch :reset_password
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'about/about'
  get 'about/accounts'
  get 'about/entries'
  get 'about/banking'
  get 'about/reports'
  get 'about/checking'

  get 'welcome/home'
  get 'welcome/test'
  get 'welcome/about'

  get 'login', to: 'users#login', as: 'login'
  get 'logout', to: 'users#logout', as: 'logout'
  get 'profile', to: 'users#profile'


  root "welcome#home"

end
