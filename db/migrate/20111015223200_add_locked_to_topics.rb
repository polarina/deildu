class AddLockedToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :locked, :boolean, :default => false, :null => false
  end
end
