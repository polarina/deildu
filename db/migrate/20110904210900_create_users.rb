class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps :null => false
      t.string :username, :null => false
      t.string :password_digest, :null => false
      t.string :email, :limit => 320, :null => false
      
      t.decimal :downloaded, :precision => 45, :default => 0, :null => false
      t.decimal :uploaded, :precision => 45, :default => 0, :null => false
    end
    
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
  end
end
