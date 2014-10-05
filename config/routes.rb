BuzzApp::Application.routes.draw do

  root :to => 'buzz#index'

  get '/buzz', :to => 'buzz#index'

  get '/buzzin', :to => 'buzz#buzz'

end
