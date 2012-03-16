class Mage::Arrangement < Mage::Base
  ##
  # Use custom all method that limits per year
  # takes optional param organ_number
  def self.all(year, organ_number=nil)
    params = organ_number ? {:organ_number=>organ_number} : {}
    res = Mage::ApiCall.call("/#{table_name.pluralize}/#{year}.json",nil,params, :get)
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
