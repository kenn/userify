require 'userify/extensions/errors'
require 'userify/extensions/rescue'
require 'userify/authentication'
require 'userify/user'

class ActionController::Routing::RouteSet
  def load_routes_with_userify!
    userify_routes = File.join(File.dirname(__FILE__), *%w[.. config userify_routes.rb])
    add_configuration_file(userify_routes) unless configuration_files.include? userify_routes
    load_routes_without_userify!
  end
  
  alias_method_chain :load_routes!, :userify
end
