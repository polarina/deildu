class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.timestamps :null => false
      t.references :torrent, :null => false
      t.references :user, :null => false
      t.binary :peer_id, :null => false
      t.string :ip, :null => false
      t.integer :port, :null => false
      t.decimal :uploaded, :precision => 45, :null => false
      t.decimal :downloaded, :precision => 45, :null => false
      t.decimal :left, :precision => 45, :null => false
    end
    
    add_index :peers, :user_id
    add_index :peers, [:torrent_id, :peer_id], :unique => true
  end
end
