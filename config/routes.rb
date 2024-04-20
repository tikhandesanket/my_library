Rails.application.routes.draw do
  namespace :api do
    get 'orders/create'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post '/order', to: 'orders#order_item'
  post '/return', to: 'orders#return_item'
  # Defines the root path route ("/")
  root "dashboard#index"
  # get 'dashboard/index'


  namespace :api,defaults: { format: 'json'} do
    get "/library_items" => "orders#library_items"
    post "/order_items" => "orders#order_items"
    post "/return_items" => "orders#return_items"

  end


end