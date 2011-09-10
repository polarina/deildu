class AddKeyToUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
    def update_passkey
      self.key = SecureRandom::urlsafe_base64(16)
    end
  end
  
  def up
    add_column :users, :key, :string
    
    User.all.each do |user|
      user.update_passkey
      user.save!
    end
    
    change_column :users, :key, :string, :null => false
  end
  
  def down
    drop_column :users, :key
  end
end
