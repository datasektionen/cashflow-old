class BusinessUnit < ActiveRecord::Base
  validates_presence_of :name, :short_name, :description
  
  has_many :purchases, :dependent => :restrict
  has_many :budget_posts

  has_friendly_id :short_name

  default_scope order("name ASC")
  
  def to_s
    "%s (%s)" % [name, short_name]
  end
  
  def active_text
    active? ? "Ja" : "Nej"
  end
end
