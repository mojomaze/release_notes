ReleaseNotes::Application.routes.draw do |map|
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  resources :users do
    collection do
      post :list_action
    end
  end
  
  resources :user_sessions

  resources :releases do
    collection do
      post :list_action
    end
    member do
      get :rollback
      get :archive
    end
  end
  
  resources :archives do
    collection do
      post :list_action
    end
    member do
      get :unarchive
    end
  end
  
  # user prefs
  get "user_preferences/edit"
  post "user_preferences/update"

  #login
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  root :to => "user_sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
#== Route Map
# Generated on 18 Oct 2011 13:52
#
#                   users GET    /users(.:format)                   {:action=>"index", :controller=>"users"}
#                         POST   /users(.:format)                   {:action=>"create", :controller=>"users"}
#                new_user GET    /users/new(.:format)               {:action=>"new", :controller=>"users"}
#               edit_user GET    /users/:id/edit(.:format)          {:action=>"edit", :controller=>"users"}
#                    user GET    /users/:id(.:format)               {:action=>"show", :controller=>"users"}
#                         PUT    /users/:id(.:format)               {:action=>"update", :controller=>"users"}
#                         DELETE /users/:id(.:format)               {:action=>"destroy", :controller=>"users"}
#           user_sessions GET    /user_sessions(.:format)           {:action=>"index", :controller=>"user_sessions"}
#                         POST   /user_sessions(.:format)           {:action=>"create", :controller=>"user_sessions"}
#        new_user_session GET    /user_sessions/new(.:format)       {:action=>"new", :controller=>"user_sessions"}
#       edit_user_session GET    /user_sessions/:id/edit(.:format)  {:action=>"edit", :controller=>"user_sessions"}
#            user_session GET    /user_sessions/:id(.:format)       {:action=>"show", :controller=>"user_sessions"}
#                         PUT    /user_sessions/:id(.:format)       {:action=>"update", :controller=>"user_sessions"}
#                         DELETE /user_sessions/:id(.:format)       {:action=>"destroy", :controller=>"user_sessions"}
#    list_action_releases POST   /releases/list_action(.:format)    {:action=>"list_action", :controller=>"releases"}
#        rollback_release GET    /releases/:id/rollback(.:format)   {:action=>"rollback", :controller=>"releases"}
#         archive_release GET    /releases/:id/archive(.:format)    {:action=>"archive", :controller=>"releases"}
#                releases GET    /releases(.:format)                {:action=>"index", :controller=>"releases"}
#                         POST   /releases(.:format)                {:action=>"create", :controller=>"releases"}
#             new_release GET    /releases/new(.:format)            {:action=>"new", :controller=>"releases"}
#            edit_release GET    /releases/:id/edit(.:format)       {:action=>"edit", :controller=>"releases"}
#                 release GET    /releases/:id(.:format)            {:action=>"show", :controller=>"releases"}
#                         PUT    /releases/:id(.:format)            {:action=>"update", :controller=>"releases"}
#                         DELETE /releases/:id(.:format)            {:action=>"destroy", :controller=>"releases"}
#    list_action_archives POST   /archives/list_action(.:format)    {:action=>"list_action", :controller=>"archives"}
#       unarchive_archive GET    /archives/:id/unarchive(.:format)  {:action=>"unarchive", :controller=>"archives"}
#                archives GET    /archives(.:format)                {:action=>"index", :controller=>"archives"}
#                         POST   /archives(.:format)                {:action=>"create", :controller=>"archives"}
#             new_archive GET    /archives/new(.:format)            {:action=>"new", :controller=>"archives"}
#            edit_archive GET    /archives/:id/edit(.:format)       {:action=>"edit", :controller=>"archives"}
#                 archive GET    /archives/:id(.:format)            {:action=>"show", :controller=>"archives"}
#                         PUT    /archives/:id(.:format)            {:action=>"update", :controller=>"archives"}
#                         DELETE /archives/:id(.:format)            {:action=>"destroy", :controller=>"archives"}
#   user_preferences_edit GET    /user_preferences/edit(.:format)   {:controller=>"user_preferences", :action=>"edit"}
# user_preferences_update POST   /user_preferences/update(.:format) {:controller=>"user_preferences", :action=>"update"}
#                   login        /login(.:format)                   {:action=>"new", :controller=>"user_sessions"}
#                  logout        /logout(.:format)                  {:action=>"destroy", :controller=>"user_sessions"}
#                    root        /(.:format)                        {:controller=>"user_sessions", :action=>"new"}
