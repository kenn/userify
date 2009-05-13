--- !ruby/object:Gem::Specification 
name: userify
version: !ruby/object:Gem::Version 
  version: 0.1.1
platform: ruby
authors: 
- Kenn Ejima
autorequire: 
bindir: bin
cert_chain: []

date: 2009-05-13 00:00:00 +09:00
default_executable: 
dependencies: []

description: Super simple authentication system for Rails, using username, email and password.
email: kenn.ejima <at> gmail.com
executables: []

extensions: []

extra_rdoc_files: []

files: 
- CHANGELOG.textile
- LICENSE
- Rakefile
- README.textile
- TODO.textile
- app/controllers
- app/controllers/userify
- app/controllers/userify/user_controller.rb
- app/models
- app/models/userify_mailer.rb
- app/views
- app/views/layouts
- app/views/layouts/_error_messages.html.haml
- app/views/layouts/application.html.haml
- app/views/user
- app/views/user/forgot.html.haml
- app/views/user/reset.html.haml
- app/views/user/signin.html.haml
- app/views/user/signup.html.haml
- app/views/userify_mailer
- app/views/userify_mailer/confirmation.html.erb
- app/views/userify_mailer/reset_password.html.erb
- config/userify_routes.rb
- generators/userify
- generators/userify/lib
- generators/userify/lib/insert_commands.rb
- generators/userify/lib/rake_commands.rb
- generators/userify/templates
- generators/userify/templates/migrations
- generators/userify/templates/migrations/create_users.rb
- generators/userify/templates/README
- generators/userify/templates/uid.rb
- generators/userify/templates/user.rb
- generators/userify/USAGE
- generators/userify/userify_generator.rb
- lib/userify
- lib/userify/authentication.rb
- lib/userify/extensions
- lib/userify/extensions/errors.rb
- lib/userify/extensions/rescue.rb
- lib/userify/user.rb
- lib/userify.rb
- rails/init.rb
has_rdoc: true
homepage: http://github.com/kenn/userify
licenses: []

post_install_message: 
rdoc_options: []

require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
requirements: []

rubyforge_project: 
rubygems_version: 1.3.3
signing_key: 
specification_version: 3
summary: Super simple authentication system for Rails, using username, email and password.
test_files: []

