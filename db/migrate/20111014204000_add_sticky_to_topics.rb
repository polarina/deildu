class AddStickyToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :sticky, :boolean, :default => false, :null => false
    
    remove_index :topics, :forum_id
    add_index :topics, [:forum_id, :sticky]
  end
end
