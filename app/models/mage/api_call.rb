class Mage::ApiCall
  def self.call(path, person, params)
    full_call(
      "#{Cashflow::Application.settings["mage_url"])}/#{path}",
      Cashflow::Application.settings["mage_apikey"],
      Cashflow::Application.settings["mage_private_apikey"],
      person.ugid,
      params
    )
  end
private
  def self.full_call(url, key, private_key, user_ugid, params)
    require 'net/http'
    require 'uri'
    params["apikey"]=key
    #params["action"]=action
    #params["controller"]=controller
    params["ugid"] = user_ugid
    body = params.to_json
    checksum = create_hash(body,private_key)
  
    url_ = "#{Cashflow::Application.settings["mage_url"])}#{url}?checksum=#{checksum}"
    uri = URI.parse url_

    request = Net::HTTP::Post.new(url_)
    request.add_field "Content-Type", "application/json"
    request.body = body
  
    http = Net::HTTP.new(uri.host,uri.port)
    res = http.request request
  end

  def self.create_hash(body, private_key)
    require 'digest/sha1'
    string = "#{body}#{private_key}"
    puts string
    Digest::SHA1.hexdigest(string)
  end

end