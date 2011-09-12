Deildu::Application.routes.draw do
  resources :forums do
    resources :posts
  end
  
  resources :pages
  resources :torrents
  resources :users do
    resources :invitations
    
    collection do
      get 'auth'
      post 'auth'
      delete 'auth'
    end
  end
  
  match "announce" => "torrents#announce", :via => :get
  match "scrape" => "torrents#scrape", :via => :get
  
  match ":section(/:id)" => "pages#page", :via => :get, :section => /help|rules/, :id => /[a-z0-9-]+/
  
  root :to => "front#index"
end
