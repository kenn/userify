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
        
        before_validation :normalize_email
        
        validates_presence_of     :username
        validates_length_of       :username, :maximum => columns_hash['username'].limit
        validates_uniqueness_of   :username
        validates_presence_of     :email
        validates_length_of       :email, :maximum => columns_hash['email'].limit
        validates_uniqueness_of   :email, :case_sensitive => false
        validates_format_of       :email, :with => /.+@.+\..+/
        validates_presence_of     :password, :if => :password_required?
        validates_length_of       :fullname, :maximum => columns_hash['fullname'].limit
        
        before_save :initialize_salt, :encrypt_password, :initialize_token
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
        token_expires_at and Time.now.utc < token_expires_at
      end
      
      def remember_me!(duration=183)
        remember_me_until! duration.days.from_now.utc
      end
      
      def forget_me!
        clear_token
        save(false)
      end
      
      def confirm_email!
        self.email_confirmed  = true
        clear_token
        save(false)
      end
      
      def forgot_password!
        generate_token 24.hours.from_now.utc
        save(false)
      end
      
      def update_password(new_password)
        self.password = new_password
        clear_token if valid?
        save
      end
      
    protected
      
      def generate_random_base62(n=27)
        UID.new(n).to_s
      end
      
      def normalize_email
        self.email.downcase!
        return true
      end
      
      def initialize_salt
        self.salt = generate_random_base62 if new_record?
      end
      
      def encrypt_password
        return if password.blank?
        self.encrypted_password = encrypt(password)
      end
      
      def generate_token(time=nil)
        self.token            = generate_random_base62
        self.token_expires_at = time
      end
      
      def clear_token
        self.token            = nil
        self.token_expires_at = nil
      end
      
      def initialize_token
        generate_token 24.hours.from_now.utc if new_record?
      end
      
      def password_required?
        encrypted_password.blank? or !password.blank?
      end
      
      def remember_me_until!(time)
        self.token            = generate_random_base62
        self.token_expires_at = time
        save(false)
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
