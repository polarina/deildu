class AddShowAvatarsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :show_avatars, :boolean, :default => true, :null => false
  end
end
