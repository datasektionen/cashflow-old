require 'fake/bookkeeper'
require 'mage/bookkeeper'

class Bookkeeper
  def self.new(purchase)
    bookkeeper_type = Cashflow::Application.settings.fetch(:bookkeeper)
    case bookkeeper_type
    when 'mage'
      Mage::Bookkeeper.new(purchase)
    when 'fake'
      Fake::Bookkeeper.new(purchase)
    else
      fail "Unknown bookkeeper type #{bookkeeper_type.inspect}"
    end
  end
end
