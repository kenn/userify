Userify
=======

Super simple authentication system for Rails, using username, email and password.

Userify focuses on the following 6 conventional actions, and that's all.

( signup / signin / signout / activate / forgot / reset )

Userify is inspired by **Clearance** <http://github.com/thoughtbot/clearance>.

Limitations
-----------

Currently, Userify is available only when you create a new project. Don't expect it to work in existing projects.

Requirements
------------

Userify requires Haml. However, when you override the default template, you don't have to use Haml.

How to use it?
--------------

Here's the setup method.

Install Userify gem, as well as Haml.

    sudo gem install haml
    sudo gem install userify

In config/environment.rb:

    config.gem "haml"
    config.gem "userify"
    UserifyMailer.sender_address = %("Do Not Reply" <donotreply@example.com>)

Run the generator:

    script/generate userify

In config/environments/development.rb and test.rb:

    config.action_mailer.default_url_options = { :host => "localhost", :port => 3000 }

In config/environments/production.rb:

    config.action_mailer.default_url_options = { :host => "example.com" }

Define root_url to *something* in your config/routes.rb. Assuming home controller for root:

    map.root :controller => 'home'

Create user_controller.rb and home_controller.rb:

    script/generate controller user
    script/generate controller home

Rewrite user_controller.rb as follows:

    class UserController < Userify::UserController
    end

Edit home_controller.rb:

    class HomeController < ApplicationController
      def index
      end
    end

Create app/views/home/index.html.haml:

    - if signed_in?
      %p= "Hello #{current_user.name}!"
    %h1 Home
    %p My app home
    - if signed_in?
      %p= link_to 'sign out', signout_url
    - else
      %p= link_to 'sign up', signup_url
      %p= link_to 'sign in', signin_url

Rename public/index.html:

    mv public/index.html public/_index.html

Run migration and start server:

    rake db:migrate
    script/server

Now, go to <http://localhost:3000/> and check how everything works.

Customize
=========

There are a couple of ways to customize Userify:

### 1. Override methods in the user_controller subclass.

You might want to override the following methods in your user_controller subclass.

UserController methods:

    url_after_signup
    url_after_signin
    url_after_signout
    url_after_activate
    url_after_forgot
    url_after_reset

View templates:

    app/views/layouts/application.html.haml
    app/views/layouts/_error_messages.html.haml
    app/views/user/forgot.html.haml
    app/views/user/reset.html.haml
    app/views/user/signin.html.haml
    app/views/user/signup.html.haml
    app/views/userify_mailer/confirmation.html.erb
    app/views/userify_mailer/reset_password.html.erb


### 2. Unpack Userify gem into vendor/gems and directly edit source.

    rake gems:unpack GEM=userify
