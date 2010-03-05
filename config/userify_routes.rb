ActionController::Routing::Routes.draw do |map|
  map.with_options(:controller => 'userify/user') do |route|
    route.signup 'signup', :action => 'signup'
    route.signin 'signin', :action => 'signin'
    route.signout 'signout', :action => 'signout'
    route.activate 'user/activate/:token', :action => 'activate'
    route.forgot 'user/forgot', :action => 'forgot'
    route.reset 'user/reset/:token', :action => 'reset'
  end
end
