class RecreateNews < ActiveRecord::Migration
  def change
    drop_table :news if ActiveRecord::Base.connection.tables.include?(:news)
    
    create_table :news do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.text :content, :null => false
    end
    
    add_index :news, :created_at
    add_index :news, :user_id
  end
end
