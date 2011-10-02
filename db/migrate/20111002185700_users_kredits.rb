class UsersKredits < ActiveRecord::Migration
  def change
    add_column :users, :kredits, :decimal, :precision => 45, :scale => 0, :default => 0, :null => false
    remove_column :users, :downloaded
    remove_column :users, :uploaded
  end
end
