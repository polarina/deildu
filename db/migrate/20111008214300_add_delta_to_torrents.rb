class AddDeltaToTorrents < ActiveRecord::Migration
  def change
    add_column :torrents, :delta, :boolean, :default => true, :null => false
  end
end
