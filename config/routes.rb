Deildu::Application.routes.draw do
  resources :forums do
    resources :posts
  end
  
  resources :invitations
  
  resources :messages do
    collection do
      get 'inbox'
      get 'outbox'
    end
  end
  
  resources :pages
  
  resources :torrents do
    resources :comments
  end
  
  resources :users do
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
