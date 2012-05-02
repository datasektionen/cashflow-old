class Mage::Account < Mage::Base
  ##
  # Use custom all method that limits per year
  # If year is not set the last year from activity_year will be used
  def self.all(year=nil)
      year = Mage::ActivityYear.all.last.year if year.nil?
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