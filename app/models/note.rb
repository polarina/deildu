class Note < ActiveRecord::Base
  belongs_to :report
  belongs_to :user
  
  def content
    note
  end
end
