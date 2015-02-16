class BusinessUnit < ActiveRecord::Base
  extend FriendlyId
  friendly_id :short_name
  validates_presence_of :name, :short_name, :description
  validates :mage_number, presence: true
  validates :mage_default_series, presence: true

  has_many :budget_posts
  has_many :purchases, through: :budget_posts

  default_scope -> { order('name ASC') }

  def to_s
    name
  end

  def active_text
    active? ? 'Ja' : 'Nej'
  end
end
