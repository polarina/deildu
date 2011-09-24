class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.timestamps :null => false
      t.integer :parent_id
      t.integer :sender_id, :null => false
      t.integer :receiver_id, :null => false
      t.boolean :sender_deleted, :null => false
      t.boolean :receiver_deleted, :null => false
      t.string :subject, :null => false
      t.text :message, :null => false
    end
    
    add_index :messages, [:receiver_id, :receiver_deleted, :created_at], :name => "index_receiver"
    add_index :messages, [:sender_id, :sender_deleted, :created_at], :name => "index_sender"
  end
end
