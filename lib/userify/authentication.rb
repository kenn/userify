module Userify
  module Authentication
    
    def self.included(controller)
      controller.send(:include, InstanceMethods)
      
      controller.class_eval do
        helper_method :current_user
        helper_method :signed_in?
        
        hide_action :current_user, :signed_in?
      end
    end
    
    module InstanceMethods
      def current_user
        @_current_user ||= (user_from_cookie or user_from_session)
      end
      
      def signed_in?
        !current_user.nil?
      end
      
    protected
    
      def authenticate
        deny_access unless signed_in?
      end
      
      def user_from_session
        if session[:user_id]
          return nil  unless user = ::User.find_by_id(session[:user_id])
          return user if user.is_email_confirmed?
        end
      end
      
      def user_from_cookie
        if token = cookies[:remember_token]
          return nil  unless user = ::User.find_by_token(token)
          return user if user.remember?
        end
      end
      
      def sign_in(user)
        if user
          session[:user_id] = user.id
        end
      end
      
      def redirect_back_or(default)
        session[:return_to] ||= params[:return_to]
        if session[:return_to]
          redirect_to(session[:return_to])
        else
          redirect_to(default)
        end
        session[:return_to] = nil
      end
      
      def redirect_to_root
        redirect_to root_url
      end
      
      def store_location(referer=false)
        session[:return_to] = referer ? request.env["HTTP_REFERER"] : request.request_uri if request.get?
      end
      
      def deny_access(flash_message = nil, opts = {})
        store_location
        flash[:error] = flash_message if flash_message
        redirect_to signin_url
      end
    end
    
  end
end
