require 'digest/sha1'

module Userify
  module User
    
    def self.included(model)
      require 'userify/uid'
      
      model.extend ClassMethods
      model.send(:include, InstanceMethods)
      
      model.class_eval do
        attr_accessible :username, :email, :password, :fullname
        attr_accessor :password
        
        validates_length_of       :username, :maximum => columns_hash['username'].limit
        validates_uniqueness_of   :username, :case_sensitive => false
        validates_length_of       :email, :maximum => columns_hash['email'].limit
        validates_format_of       :email, :with => /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$/
        validates_uniqueness_of   :email, :case_sensitive => false
        validates_presence_of     :password, :if => :password_required?
        validates_length_of       :fullname, :maximum => columns_hash['fullname'].limit, :allow_nil => true
        
        before_validation           :userify_before_validation
        before_validation_on_create :userify_before_validation_on_create
        before_save                 :userify_before_save
      end
    end
    
    module InstanceMethods
      def name
        self.fullname or self.username
      end
      
      def authenticated?(password)
        encrypted_password == encrypt(password)
      end
      
      def encrypt(string)
        Digest::SHA1.hexdigest("--#{salt}--#{string}--")
      end
      
      def remember?
        is_email_confirmed? and token_expires_at and Time.now < token_expires_at
      end
      
      def remember_me!(duration=183)
        set_token duration.days.from_now unless remember?
        save
      end
      
      def confirm_email!
        self.is_email_confirmed  = true
        clear_token
        save
      end
      
      def update_password(new_password)
        self.password = new_password
        clear_token if valid?
        save
      end
      
      def set_token!(expires_at=nil)
        set_token expires_at
        save
      end
      
      def clear_token!
        clear_token
        save
      end
      
    protected
      
      def set_token(expires_at=nil)
        self.token            = UID.new(27).to_s
        self.token_expires_at = expires_at
      end
      
      def clear_token
        self.token            = nil
        self.token_expires_at = nil
      end
      
      def password_required?
        encrypted_password.blank?
      end
      
      def userify_before_validation
        self.email.downcase! unless self.email.nil?
      end
      
      def userify_before_validation_on_create
        self.salt = UID.new(27).to_s
        set_token 24.hours.from_now
      end
      
      def userify_before_save
        self.encrypted_password = encrypt(password) unless self.password.blank?
      end
    end
    
    module ClassMethods
      def authenticate(email_or_username, password)
        user = find(:first, :conditions => ['username = ? OR email = ?', email_or_username, email_or_username])
        user && user.authenticated?(password) ? user : nil
      end
    end
    
  end
end
