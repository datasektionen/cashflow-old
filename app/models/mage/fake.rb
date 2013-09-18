require 'ostruct'

class Mage::Fake
  def method_missing(*args)
    return OpenStruct.new
  end
end
