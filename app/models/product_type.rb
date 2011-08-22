class ProductType < ActiveRecord::Base
  validates_presence_of :name, :description
  
  has_many :purchase_items, :dependent => :restrict

  default_scope order("name ASC")
  
  def to_s
    name
  end
end
