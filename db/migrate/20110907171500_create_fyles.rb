class CreateFyles < ActiveRecord::Migration
  def change
    create_table :fyles do |t|
      t.references :torrent, :null => false
      t.integer :ordering, :null => false
      t.decimal :size, :precision => 45, :null => false
      t.string :path, :null => false
    end
    
    add_index :fyles, [:torrent_id, :ordering], :unique => true
    add_index :fyles, [:torrent_id, :path], :unique => true
  end
end
