class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.timestamps :null => false
      t.integer :ordering, :null => false
      t.string :title, :null => false
      t.string :description, :null => false
    end
    
    add_index :forums, :ordering, :unique => true
    
    create_table :topics do |t|
      t.timestamps :null => false
      t.references :forum, :null => false
      t.references :user, :null => false
      t.string :subject, :null => false
      t.text :post, :null => false
    end
    
    add_index :topics, :forum_id
    
    create_table :posts do |t|
      t.timestamps :null => false
      t.references :topic, :null => false
      t.references :user, :null => false
      t.text :post, :null => false
    end
    
    add_index :posts, [:user_id, :created_at]
    add_index :posts, [:topic_id, :created_at]
  end
end
