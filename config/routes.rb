BuzzApp::Application.routes.draw do

  root :to => 'buzz#index'

  get '/buzz', :to => 'buzz#index'

  post '/buzz', :to => 'buzz#buzz'

  get '/controls', :to => 'buzz#controls'

  get '/reset', :to => 'buzz#reset'

  get '/start', :to => 'buzz#start'

  get '/pause', :to => 'buzz#pause'

end
