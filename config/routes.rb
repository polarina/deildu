Deildu::Application.routes.draw do
  resources :bans
  resources :blocks
  
  resources :forums do
    resources :topics, :path => "/", :constraints => { :id => /\d+/ }, :except => :index do
      resources :posts, :path => "/", :constraints => { :id => /\d+/ }, :except => :index
    end
  end
  
  resources :invitations
  
  resources :messages do
    collection do
      get 'inbox'
      get 'outbox'
    end
  end
  
  resources :news
  resources :pages
  
  resources :reports do
    resources :notes
  end
  
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
