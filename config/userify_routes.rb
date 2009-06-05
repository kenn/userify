ActionController::Routing::Routes.draw do |map|
  map.signup 'user/signup', :controller => 'userify/user', :action => 'signup'
  map.signin 'user/signin', :controller => 'userify/user', :action => 'signin'
  map.signout 'user/signout', :controller => 'userify/user', :action => 'signout'
  map.activate 'user/activate/:token', :controller => 'userify/user', :action => 'activate'
  map.forgot 'user/forgot', :controller => 'userify/user', :action => 'forgot'
  map.reset 'user/reset/:token', :controller => 'userify/user', :action => 'reset'
end
