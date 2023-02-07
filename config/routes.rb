Rails.application.routes.draw do
  
  resources :users do 
    resources :articles
  end

  post '/auth/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
