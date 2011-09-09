class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.string :key, :null => false
      t.string :email, :limit => 320, :null => false
    end
    
    add_index :invitations, :key, :unique => true
    add_index :invitations, [:email, :user_id], :unique => true
  end
end
