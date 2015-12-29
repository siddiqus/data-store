DataEntry::Application.routes.draw do

  resources :drugs
  resources :products
  resources :tweets do 
    get :autocomplete_tweet_text, :on => :collection  
  end
  
  devise_for :users, :controllers => {:registrations => "registrations"}

  get "admin/users"
  post "admin/promote"
  post "admin/demote"
  post "admin/approve"
  post "admin/disable"

  root :to => 'home#index'


  get "tweets", to: 'home#tweets'

  # get 'print_xls', :to => 'drugs#print_xls'
  get 'print_xls', :to => 'home#print_xls'

  # put 'upload_pic/:id', :to => 'drugs#upload_pic'
  put 'upload_pic/:id', :to => 'products#upload_pic'

  # get "search", :to => "drugs#search"
  get "search", :to => "tweets#search"

end
