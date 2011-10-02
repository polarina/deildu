class AddAllowedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allowed, :boolean, :default => true, :null => false
  end
end
