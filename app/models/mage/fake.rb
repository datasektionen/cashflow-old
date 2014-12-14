require 'ostruct'

class Mage::Fake
  def method_missing(*_args)
    OpenStruct.new
  end
end
