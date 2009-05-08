class UserifyCreateUsers < ActiveRecord::Migration
  def self.up
    
    case connection.adapter_name
    when 'MySQL'
      execute "ALTER DATABASE #{connection.current_database} CHARACTER SET utf8 COLLATE utf8_bin"
      no_case_collation = 'utf8_general_ci'
      mysql = true
    when 'SQLite'
      # COLLATE BINARY by default
      no_case_collation = 'NOCASE'
      mysql = false
    end
    
    create_table :users do |t|
      t.string   :email,              :limit => 60, :null => false
      t.string   :fullname,           :limit => 60
      t.string   :encrypted_password, :limit => 40, :null => false
      t.string   :salt,               :limit => 40, :null => false
      t.string   :token,              :limit => 27
      t.datetime :token_expires_at
      t.boolean  :email_confirmed, :default => false, :null => false
      t.timestamps
    end
    
    execute "ALTER TABLE users ADD username VARCHAR(30) #{mysql ? 'CHARACTER SET utf8' : ''} COLLATE #{no_case_collation}"
    
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
    add_index :users, :token, :unique => true
  end
  
  def self.down
    drop_table :users  
  end
end
