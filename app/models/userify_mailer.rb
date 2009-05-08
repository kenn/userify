class UserifyMailer < ActionMailer::Base
  
  default_url_options[:host] = HOST
  
  def reset_password(user)
    from       DO_NOT_REPLY
    recipients user.email
    subject    "Reset your password"
    body       :user => user
  end
  
  def confirmation(user)
    from       DO_NOT_REPLY
    recipients user.email
    subject   "Account confirmation"
    body      :user => user
  end
  
end
