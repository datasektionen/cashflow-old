module Mage
  class ApiCall
    # Method == :get, :post, :put or :delete
    def self.call(path, person, params, method)
      path = path[1..-1] if path[0] == '/' # Trim starting /
      full_call(
        "#{Cashflow::Application.settings['mage_url']}/#{path}",
        Cashflow::Application.settings['mage_apikey'],
        Cashflow::Application.settings['mage_private_apikey'],
        person ? person.ugid : nil,
        params,
        method
      )
    end

    def self.full_call(url, key, private_key, user_ugid, params, method)
      require 'net/http'
      require 'uri'
      params['apikey'] = key
      params['ugid'] = user_ugid if user_ugid
      body = params.to_json
      checksum = create_hash(body, private_key)

      url_ = "#{url}?checksum=#{checksum}"
      uri = URI.parse url_

      case method
      when :get
        request = Net::HTTP::Get.new(url_)
      when :post
        request = Net::HTTP::Post.new(url_)
      when :put
        request = Net::HTTP::Put.new(url_)
      when :delete
        request = Net::HTTP::Delete.new(url_)
      else
        fail 'Invalid method!'
      end
      request.add_field 'Content-Type', 'application/json'
      request.body = body

      http = Net::HTTP.new(uri.host, uri.port)
      http.request(request)
    end

    def self.create_hash(body, private_key)
      require 'digest/sha1'
      string = "#{body}#{private_key}"
      cs = Digest::SHA1.hexdigest(string)
      cs
    end
  end
end
