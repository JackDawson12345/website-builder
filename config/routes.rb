Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  # Admin routes
  namespace :admin do
    resources :components do
      member do
        get :preview
      end
    end

    resources :themes do
      member do
        get :preview
      end
      resources :theme_pages do
        member do
          patch :reorder_components
        end
        resources :theme_page_components, only: [:create, :destroy]
      end
    end

    root 'dashboard#index'
  end

  # Customer routes
  namespace :customer do
    resource :website do
      member do
        get :preview
        patch :publish
        patch :unpublish
        get :settings  # Add settings route
        patch :update_settings  # Add update settings route
      end
    end

    # Customer contents routes - updated to handle JSON responses
    resources :contents, only: [:edit, :update] do
      member do
        patch :update_field # For individual field updates if needed
      end
    end

    root 'dashboard#index'
  end

  # Public website preview
  get '/:subdomain', to: 'public_websites#show', constraints: { subdomain: /[a-z0-9\-]+/ }
end