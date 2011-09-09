Deildu::Application.routes.draw do
  resources :forums do
    resources :posts
  end
  
  resources :torrents
  resources :users do
    resources :invitations
    
    collection do
      get 'auth'
      post 'auth'
      delete 'auth'
    end
  end
  
  match "announce", :to => "torrents#announce"
  match "scrape", :to => "torrents#scrape"
  
  root :to => "front#index"
end
