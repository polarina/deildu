class AddVisitedAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :visited_at, :datetime, :default => Time.now.utc, :null => false
    change_column :users, :visited_at, :datetime, :null => false
    
    add_index :users, :visited_at
  end
  
  def down
    remove_column :users, :visited_at
  end
end
