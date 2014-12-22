require 'mage/voucher'

module Mage
  class Bookkeeper
    def initialize(purchase)
      @purchase = purchase
    end

    def keep
      voucher = Mage::Voucher.from_purchase(purchase)
      unless voucher.push(purchase.last_updated_by)
        fail "An error occured when pushing #{purchase.inspect} to MAGE (push returned false)"
      end
    end

    private

    attr_reader :purchase
  end
end
