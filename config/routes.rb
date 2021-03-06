Rails.application.routes.draw do
  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  resources :sessions, only: [:new, :create, :destroy]

  resources :users

  resources :main, only: [:index]

  resources :traceresult, only: [:index]

  resources :jsondata, only: [:index]

  match 'mainuser/changedetail', :to => 'mainuser#changedetail', 
                       :via => :get

  match 'mainuser/changepassword', :to => 'mainuser#changepassword', 
                       :via => :get

  match 'mainuser/updatedetail', :to => 'mainuser#updatedetail', 
                       :via => :post

  match 'mainuser/updatepassword', :to => 'mainuser#updatepassword', 
                       :via => :post

  match 'users/freeze/id', :to => 'users#freeze', 
                       :via => :patch

  match 'users/unfreeze/id', :to => 'users#unfreeze', 
                       :via => :patch

  match 'users/child/id', :to => 'users#child', 
                       :via => :get

  match 'tracelogs/single', :to => 'tracelogs#single', 
                       :via => :post

  match 'tracelogs/double', :to => 'tracelogs#double', 
                       :via => :post

  match 'tracelogs/combination', :to => 'tracelogs#combination', 
                       :via => :post

  resources :flashview, only: [:index]

  resources :tracelogs, only: [:index]
  
  resources :manage, only: [:index, :show]

  resources :operlogs, only: [:index]

  resources :gridgame, only: [:index]

  resources :task, only: [:index]

  resources :gridconfig

  resources :loginlogs, only: [:index]

  resources :mainhistory, only: [:index]

  resources :maingridgame, only: [:index]

  resources :singlegame, only: [:index]

  resources :combinationgame, only: [:index]

  resources :doublegame, only: [:index]

  resources :mainuser, only: [:index]

  resources :userreport, only: [:index]
  
  # You can have the root of your site routed with "root"
  root 'main#index'

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
