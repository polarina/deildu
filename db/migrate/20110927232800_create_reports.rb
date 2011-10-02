class CreateReports < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :status, :null => false
    end
    
    create_table :reports do |t|
      t.timestamps :null => false
      t.references :user, :null => false
      t.references :status, :null => false
      t.string :victim_type, :null => false
      t.integer :victim_id, :null => false
      t.text :reason, :null => false
    end
    
    add_index :reports, :user_id
    add_index :reports, :status_id
    
    create_table :notes do |t|
      t.timestamps :null => false
      t.references :report, :null => false
      t.references :user, :null => false
      t.text :note, :null => false
    end
    
    add_index :notes, :report_id
    add_index :notes, :user_id
  end
end
