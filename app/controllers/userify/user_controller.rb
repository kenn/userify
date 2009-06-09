class Userify::UserController < ApplicationController
  unloadable
  
  before_filter :redirect_to_root, :only => [ :signup, :signin, :activate, :forgot, :reset ], :if => :signed_in?
  filter_parameter_logging :password
  
  before_filter :assign_user_from_token,    :only => [ :activate, :reset ]
  before_filter :forbid_non_existent_token, :only => [ :activate, :reset ]
  before_filter :forbid_confirmed_user,     :only => :activate
  
  def signup
    case request.method
      
    when :get
      @user = ::User.new(params[:signup])
      render :template => 'user/signup'
      
    when :post
      @user = ::User.new(params[:signup])
      if @user.save
        ::UserifyMailer.deliver_confirmation @user
        flash[:notice] = "You will receive an email within the next few minutes. " <<
                         "It contains instructions for confirming your account."
        redirect_to url_after_signup
      else
        flash[:error] = generate_error_messages_for(@user)
        redirect_to :back
      end
    end
    
  end
  
  def signin
    case request.method
      
    when :get
      store_location(true) if session[:return_to].blank?
      render :template => 'user/signin'
      
    when :post
      @user = ::User.authenticate(params[:signin][:email], params[:signin][:password])
      if @user.nil?
        flash[:error] = "Bad email or password."
        redirect_to :back
      else
        if @user.email_confirmed?
          if params[:signin] and params[:signin][:remember_me] == "1"
            @user.remember_me!
            cookies[:remember_token] = { :value   => @user.token, :expires => @user.token_expires_at }
          end
          sign_in(@user)
          flash[:notice] = "Signed in successfully."
          redirect_back_or url_after_signin
        else
          ::UserifyMailer.deliver_confirmation(@user)
          deny_access("User has not confirmed email. Confirmation email will be resent.")
        end
      end
    end
    
  end
  
  def signout
    current_user.forget_me! if current_user
    cookies.delete :remember_token
    reset_session
    flash[:notice] = "You have been signed out."
    redirect_to url_after_signout
  end
  
  def activate
    @user.confirm_email!
    
    sign_in(@user)
    flash[:notice] = "Confirmed email and signed in."
    redirect_to url_after_activate
  end
  
  def forgot
    case request.method
      
    when :get
      render :template => 'user/forgot'
      
    when :post
      if user = ::User.find_by_email(params[:forgot][:email])
        user.forgot_password!
        ::UserifyMailer.deliver_reset_password user
        flash[:notice] = "You will receive an email within the next few minutes. " <<
                         "It contains instructions for changing your password."
        redirect_to url_after_forgot
      else
        flash[:error] = "Unknown email"
        redirect_to :back
      end
    end
    
  end
  
  def reset
    case request.method
      
    when :get
      render :template => 'user/reset'
      
    when :post
      if @user.update_password(params[:user][:password])
        @user.confirm_email! unless @user.email_confirmed?
        sign_in(@user)
        flash[:notice] = "You have successfully reset your password."
        redirect_to url_after_reset
      else
        redirect_to :back
      end
    end
    
  end
  
protected
  def url_after_signup
    root_url
  end
  
  def url_after_signin
    root_url
  end
  
  def url_after_signout
    return :back
  end
  
  def url_after_activate
    root_url
  end
  
  def url_after_forgot
    root_url
  end
  
  def url_after_reset
    root_url
  end
  
  def assign_user_from_token
    raise ActionController::Forbidden, "missing token" if params[:token].blank?
    
    @user = ::User.find_by_token(params[:token])
  end
  
  def forbid_non_existent_token
    raise ActionController::Forbidden, "non-existent token" unless @user
  end
  
  def forbid_confirmed_user
    raise ActionController::Forbidden, "confirmed user" if @user and @user.email_confirmed?
  end
  
  def generate_error_messages_for(obj)
    render_to_string :partial => 'layouts/error_messages', :object => obj.errors.full_messages
  end
end
