class BusinessUnit < ActiveRecord::Base
  validates_presence_of :name, :short_name, :description
  
  has_many :purchases, :dependent => :restrict
end
