class Mage::Arrangement < Mage::Base
  ##
  # Use custom all method that limits per year
  # If year is not set the last year from activity_year will be used
  # takes optional param organ_number
  def self.all(organ_number=nil, year=nil)
    return fake('mage.account.all') if Cashflow::Application.settings[:fake_mage]
      
    year = Mage::ActivityYear.all.last.year if year.nil?
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
