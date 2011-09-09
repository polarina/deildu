class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.timestamps :null => false
      t.references :torrent, :null => false
      t.references :user, :null => false
      t.text :comment, :null => false
    end
    
    add_index :comments, [:torrent_id, :created_at]
    add_index :comments, :user_id
  end
end
