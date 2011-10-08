class CreateReadTopic < ActiveRecord::Migration
  def change
    create_table :read_topics do |t|
      t.references :user, :null => false
      t.references :topic, :null => false
      t.references :post, :null => false
    end
    
    add_index :read_topics, [:user_id, :topic_id], :unique => true
  end
end
