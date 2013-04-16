HomeInventory::Application.routes.draw do
  resources :users, :homes
  resources :sessions, only: [:new, :create, :destroy]

  root to: 'static_pages#home'

  match '/signup',   to: 'users#new'
  match '/signin',   to: 'sessions#new'
  match '/signout',  to: 'sessions#destroy', via: :delete

  match '/help',    to: 'static_pages#help' #also creates named route called 'help_path'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

end
