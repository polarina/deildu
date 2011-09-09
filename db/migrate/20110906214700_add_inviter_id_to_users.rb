class AddInviterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :inviter_id, :integer
  end
end
