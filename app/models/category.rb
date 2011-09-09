class Category < ActiveRecord::Base
  default_scope order("title")
  
  def image_path
    Category.image_path(self.id)
  end
  
  def self.image_path(id)
    {
      1 => "categories/dvd-r.png",
      2 => "categories/annad.png",
    }[id]
  end
end
