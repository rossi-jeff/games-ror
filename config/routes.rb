Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	namespace :api do
		match '/auth/register' => 'auth#register', :via => :post, :as => :register 
		match '/auth/login' => 'auth#login', :via => :post, :as => :login
		resources :code_breaker, :only => [:index,:show,:create] do
			post 'guess'
			collection do
				get 'progress'
			end
		end
		resources :concentration, :only => [:index,:show,:create,:update]
		resources :free_cell, :only => [:index,:show,:create,:update]
		resources :guess_word, :only => [:index,:show,:create] do
			post 'guess'
			collection do
				post 'hint'
				get 'progress'
			end
		end
		resources :hang_man, :only => [:index,:show,:create] do
			post 'guess'
			collection do
				get 'progress'
			end
		end
		resources :klondike, :only => [:index,:show,:create,:update]
		resources :sea_battle, :only => [:index,:show,:create] do
			post 'ship'
			post 'fire'
			collection do
				get 'progress'
			end
		end
		resources :ten_grand, :only => [:index,:show,:create] do
			post 'roll'
			post 'score'
			collection do
				post 'options'
				get 'progress'
			end
		end
		get '/word/:id', :to => 'word#show'
		post '/word/random', :to => 'word#random'
		resources :yacht, :only => [:index,:show,:create] do
			post 'roll'
			post 'score'
			collection do
				get 'progress'
			end
		end
	end
end
