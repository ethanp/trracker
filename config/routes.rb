Rails.application.routes.draw do

  devise_for :users
  root to: "static#landing", as: :homepage

  get 'static/landing', as: :home
  get 'static/about', as: :about
  get 'static/help'

  resources :users
  shallow do
    resources :categories do
      resources :tasks do
        resources :subtasks
        resources :intervals
      end
    end
  end
  post '/tasks/:task_id/intervals-ajax' => 'intervals#create_from_ajax'
  # the record button


  # The priority is based upon order of creation: first created -> highest priority.

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
