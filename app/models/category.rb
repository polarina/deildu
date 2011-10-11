class Category < ActiveRecord::Base
  default_scope order("title")
  
  def image_path
    Category.image_path(self.id)
  end
  
  def self.image_path(id)
    {
      1 => "categories/dvd-r.png",
      2 => "categories/annad.png",
      3 => "categories/hi-def.png",
      4 => "categories/leikir.png",
      5 => "categories/thaettir.png",
    }[id]
  end
  
  def image_size
    "63x36"
  end
  
  def self.image_size
    "63x36"
  end
end
