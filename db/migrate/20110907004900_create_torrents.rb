class CreateTorrents < ActiveRecord::Migration
  def change
    create_table :torrents do |t|
      t.timestamps :null => false
      t.string :title, :null => false
      t.boolean :anonymous, :null => false
      t.references :user, :null => false
      t.references :category, :null => false
      t.text :description, :null => false
      
      t.decimal :size, :precision => 45, :null => false
      t.binary :infohash, :length => 20, :null => false
      t.string :info_name, :null => false
      t.integer :info_piece_length, :null => false
      t.binary :info_pieces, :null => false
    end
    
    add_index :torrents, :user_id
    add_index :torrents, :category_id
    add_index :torrents, :infohash, :unique => true
  end
end
