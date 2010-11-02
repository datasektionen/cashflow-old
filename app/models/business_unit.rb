class BusinessUnit < ActiveRecord::Base
  validates_presence_of :name, :short_name, :description
  
  has_many :purchases, :dependent => :restrict
  
  def to_s
    "%s (%s)" % [name, short_name]
  end
  
  def active_text
    active? ? "Ja" : "Nej"
  end
end
