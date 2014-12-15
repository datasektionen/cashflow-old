require 'webmock/rspec'

def initialize_mage_webmock
  mage_url = "#{Cashflow::Application.settings['mage_url']}"
  # accounts
  stub_request(:get, /#{mage_url}\/activity_years\/[0-9]+\/accounts\.json\?checksum=.*/).to_return(body: File.new("#{Rails.root}/spec/mage_responses/accounts.json"), status: 200)
  stub_request(:get, /#{mage_url}\/organs\.json\?checksum=.*/).to_return(body: File.new("#{Rails.root}/spec/mage_responses/organs.json"), status: 200)
  stub_request(:get, /#{mage_url}\/activity_years\.json\?checksum=.*/).to_return(body: File.new("#{Rails.root}/spec/mage_responses/activity_years.json"), status: 200)
  stub_request(:get, /#{mage_url}\/series\.json\?checksum=.*/).to_return(body: File.new("#{Rails.root}/spec/mage_responses/series.json"), status: 200)
  stub_request(:get, /#{mage_url}\/arrangements\/[0-9]+\.json\?checksum=.*/).to_return(body: File.new("#{Rails.root}/spec/mage_responses/arrangements.json"), status: 200)

  # stub_request(:get, "http://localhost:3001/activity_years.json?checksum=391e1becb95d6c914381181040f4cedc91bc228b").
  # with(:body => "{\"apikey\":\"112f748a672888172b492c7c51dc26e86b73f27e24f90d1f228388166a521295\"}",
  #:headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
  # to_return(:status => 200, :body => File.new("#{Rails.root}/spec/mage_responses/accounts.json"), :headers => {})
end
