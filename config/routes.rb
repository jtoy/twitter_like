FavRemove::Application.routes.draw do
  delete '/signout', to: 'pages#destroy', as: 'signout'
  get '/auth/twitter/callback', to: 'pages#callback', as: 'callback'
  root 'pages#home'
  get '/stats', to: 'pages#stats'
  get ':controller(/:action(/:id))'
  match '/signup',  to: 'pages#signup', via: 'get'
  get 'auth/failure' => redirect('/')
  match '/thankyou',  to: 'pages#thankyou', via: 'get'
  match '/will_pay',  to: 'pages#will_pay', via: 'post'

end
