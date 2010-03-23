require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")

class UserifyGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.insert_into "app/controllers/application_controller.rb",
                    "include Userify::Authentication"
                    
      user_model = "app/models/user.rb"
      if File.exists?(user_model)
        m.insert_into user_model, "include Userify::User"
      else
        m.directory File.join("app", "models")
        m.file "user.rb", user_model
      end
      
      m.migration_template "migrations/create_users.rb",
        'db/migrate',
        :migration_file_name => "userify_create_users"
      
      m.readme "README"
    end
  end
  
end
