class RecalculateInfohashForTorrents < ActiveRecord::Migration
  def change
    Torrent.all.each do |torrent|
      torrent.recalculate_infohash
      torrent.save!
    end
  end
end
