class UserifyMailer < ActionMailer::Base
  @@sender_address = %("Do Not Reply" <donotreply@example.com>)
  cattr_accessor :sender_address
  
  def reset_password(user)
    from       sender_address
    recipients user.email
    subject    "Reset your password"
    body       :user => user
  end
  
  def confirmation(user)
    from       sender_address
    recipients user.email
    subject   "Account confirmation"
    body      :user => user
  end
  
end
