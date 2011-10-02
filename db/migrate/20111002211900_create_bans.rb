class CreateBans < ActiveRecord::Migration
  def change
    create_table :bans do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.column :address, :inet, :null => false
    end
    
    add_index :bans, :address, :unique => true
  end
end
