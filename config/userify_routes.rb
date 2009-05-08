ActionController::Routing::Routes.draw do |map|
  map.signup 'signup', :controller => 'userify/user', :action => 'signup'
  map.signin 'signin', :controller => 'userify/user', :action => 'signin'
  map.signout 'signout', :controller => 'userify/user', :action => 'signout'
  map.activate 'activate/:token', :controller => 'userify/user', :action => 'activate'
  map.forgot 'password/forgot', :controller => 'userify/user', :action => 'forgot'
  map.reset 'password/reset/:token', :controller => 'userify/user', :action => 'reset'
end
