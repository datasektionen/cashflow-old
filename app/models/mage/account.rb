class Mage::Account < Mage::Base
  ##
  # Use custom all method that limits per year
  def self.all(year)
      res = Mage::ApiCall.call("/activity_years/#{year}/accounts.json",nil,{}, :get)
      p = parse_result(res)
      if p
        return p.map do |item|
          self.new(item)
        end
      else
        false
      end 
  end
end
