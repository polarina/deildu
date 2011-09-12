class Page < ActiveRecord::Base
  scope :ordered, reorder(:section, :uri)
  
  attr_accessible :section,
                  :uri,
                  :entry
  
  validates :section,
    :format => { :with => /^(help|rules)$/ }
  
  validates :uri,
    :uniqueness => { :scope => :section },
    :format => { :with => /^([a-z0-9-]+)$/ }
end
