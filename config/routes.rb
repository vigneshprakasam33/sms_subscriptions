SmsSubscriptions::Application.routes.draw do

  resources :supports

  resources :subscriptions

  resources :orders do
    collection do
      get :get_token
      get :express
      get :buy_more
      get :buy_more_failed
      get :pricing
      post :update_pricing
    end
  end

  resources :messages do
    collection do
      get :get_messages_on_category
      get :new_category
      post :create_category
      delete :destroy_category
      post :update_config
      post :reject
    end
  end


  resources :users do
    collection do
      post :login
      get :logout
    end
    member do
      get :buy_more
    end
  end

  get 'signin' => 'users#signin'
  get 'jobs' => 'users#jobs'
  delete 'category/:id' => 'messages#destroy_category'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'users#new'

  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
