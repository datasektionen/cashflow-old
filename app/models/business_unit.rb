class BusinessUnit < ActiveRecord::Base
  extend FriendlyId
  validates_presence_of :name, :short_name, :description
  
  has_many :budget_posts
  has_many :purchases, through: :budget_posts

  friendly_id :short_name

  default_scope order("name ASC")
  
  def to_s
    name
  end
  
  def active_text
    active? ? "Ja" : "Nej"
  end
end
