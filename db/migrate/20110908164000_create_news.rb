class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.string :title, :null => false
      t.text :news, :null => false
    end
  end
end
