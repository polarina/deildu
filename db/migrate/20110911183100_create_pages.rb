class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.timestamps :null => false
      t.string :section, :null => false
      t.string :uri, :null => false
      t.text :entry, :null => false
    end
    
    add_index :pages, [:section, :uri], :unique => true
  end
end
