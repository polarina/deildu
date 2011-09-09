# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110908210500) do

  create_table "categories", :force => true do |t|
    t.string "title", :null => false
  end

  create_table "comments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "torrent_id", :null => false
    t.integer  "user_id",    :null => false
    t.text     "comment",    :null => false
  end

  add_index "comments", ["torrent_id", "created_at"], :name => "index_comments_on_torrent_id_and_created_at"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "fyles", :force => true do |t|
    t.integer "torrent_id",                                :null => false
    t.integer "ordering",                                  :null => false
    t.decimal "size",       :precision => 45, :scale => 0, :null => false
    t.string  "path",                                      :null => false
  end

  add_index "fyles", ["torrent_id", "ordering"], :name => "index_fyles_on_torrent_id_and_ordering", :unique => true
  add_index "fyles", ["torrent_id", "path"], :name => "index_fyles_on_torrent_id_and_path", :unique => true

  create_table "invitations", :force => true do |t|
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "user_id",                   :null => false
    t.string   "key",                       :null => false
    t.string   "email",      :limit => 320, :null => false
  end

  add_index "invitations", ["key"], :name => "index_invitations_on_key", :unique => true
  add_index "invitations", ["user_id", "email"], :name => "index_invitations_on_user_id_and_email", :unique => true

  create_table "news", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id",    :null => false
    t.string   "title",      :null => false
    t.text     "news",       :null => false
  end

  create_table "peers", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "torrent_id",                                :null => false
    t.integer  "user_id",                                   :null => false
    t.binary   "peer_id",                                   :null => false
    t.string   "ip",                                        :null => false
    t.integer  "port",                                      :null => false
    t.decimal  "uploaded",   :precision => 45, :scale => 0, :null => false
    t.decimal  "downloaded", :precision => 45, :scale => 0, :null => false
    t.decimal  "left",       :precision => 45, :scale => 0, :null => false
  end

  add_index "peers", ["torrent_id", "peer_id"], :name => "index_peers_on_torrent_id_and_peer_id", :unique => true
  add_index "peers", ["user_id"], :name => "index_peers_on_user_id"

  create_table "torrents", :force => true do |t|
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.string   "title",                                                           :null => false
    t.boolean  "anonymous",                                                       :null => false
    t.integer  "user_id",                                                         :null => false
    t.integer  "category_id",                                                     :null => false
    t.text     "description",                                                     :null => false
    t.decimal  "size",              :precision => 45, :scale => 0,                :null => false
    t.binary   "infohash",                                                        :null => false
    t.string   "info_name",                                                       :null => false
    t.integer  "info_piece_length",                                               :null => false
    t.binary   "info_pieces",                                                     :null => false
    t.integer  "comments_count",                                   :default => 0, :null => false
    t.integer  "fyles_count",                                      :default => 0, :null => false
    t.integer  "leechers_count",                                   :default => 0, :null => false
    t.integer  "seeders_count",                                    :default => 0, :null => false
  end

  add_index "torrents", ["category_id"], :name => "index_torrents_on_category_id"
  add_index "torrents", ["infohash"], :name => "index_torrents_on_infohash", :unique => true
  add_index "torrents", ["user_id"], :name => "index_torrents_on_user_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                                                   :null => false
    t.datetime "updated_at",                                                                   :null => false
    t.string   "username",                                                                     :null => false
    t.string   "password_digest",                                                              :null => false
    t.string   "email",           :limit => 320,                                               :null => false
    t.decimal  "downloaded",                     :precision => 45, :scale => 0, :default => 0, :null => false
    t.decimal  "uploaded",                       :precision => 45, :scale => 0, :default => 0, :null => false
    t.integer  "inviter_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end