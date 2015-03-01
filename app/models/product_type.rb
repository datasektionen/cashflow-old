class ProductType < ActiveRecord::Base
  validates_presence_of :name, :description
  validates :mage_account_number, presence: true

  has_many :purchase_items, dependent: :restrict_with_exception

  default_scope { order("name ASC") }

  def to_s
    name
  end
end
