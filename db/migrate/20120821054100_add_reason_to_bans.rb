class AddReasonToBans < ActiveRecord::Migration
  def change
    add_column :bans, :reason, :string, :default => "", :null => false
  end
end
