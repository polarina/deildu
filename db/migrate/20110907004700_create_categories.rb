class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, :null => false
    end
  end
end
