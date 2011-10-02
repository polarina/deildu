class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.integer :blocked_id, :null => false
    end
    
    add_index :blocks, [:user_id, :blocked_id], :unique => true
  end
end
