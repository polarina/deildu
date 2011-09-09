class FixIndexOnInvitations < ActiveRecord::Migration
  def up
    remove_index :invitations, [:email, :user_id]
    add_index :invitations, [:user_id, :email], :unique => true
  end
  
  def down
    remove_index :invitations, [:user_id, :email]
    add_index :invitations, [:email, :user_id], :unique => true
  end
end
