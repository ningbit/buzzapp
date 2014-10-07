BuzzApp::Application.routes.draw do


  resources :topics do

    resources :questions

  end


  #pages

  root :to => 'buzz#index'

  get '/buzz', :to => 'buzz#index'

  get '/results', :to => 'buzz#results'

  get '/controls', :to => 'buzz#controls'

  get '/quiz', :to => 'quiz#index'

  get '/create', :to => 'quiz#create'

  # buzz actions

  post '/buzz', :to => 'buzz#buzz'

  # control actions

  get '/right', :to => 'buzz#right'

  get '/wrong', :to => 'buzz#wrong'

  get '/reset', :to => 'buzz#reset'

  get '/start', :to => 'buzz#start'

  get '/pause', :to => 'buzz#pause'

  # announcer actions

  get '/scores', :to => 'buzz#scores'

  get '/welcome-player', :to => 'buzz#welcome_player'

  get '/welcome-team', :to => 'buzz#welcome_team'

end
