require 'yaml'

class Mage::Base
  @@create_action = 'create'
  @@after_initialize = []
  @@before_initialize = []

  ##
  # Initialize an object with the specified attributes
  def initialize(attr = {})
    @attr = {}
    # Run before initialize hooks
    @@before_initialize.each { |c| send(c) }

    # If data is stored in subarray under table name, extract it
    # Ex:
    # attr[vouchers] = {:id=>0, :foo=>'bar', :baz=>'foobar'}
    # We then need to extract the hash under vouchers
    attr = attr[self.class.table_name] if attr[self.class.table_name]
    attr = attr[self.class.table_name.to_sym] if attr[self.class.table_name.to_sym]

    # Convert all keys to symbol and save internally
    attr.each do |key, val|
      @attr[key.to_sym] = val
    end

    # Run after initialize hooks
    @@after_initialize.each { |c| call(c) }
  end

  # Handle getters, setters and ?-methods
  def method_missing(method, *args)
    if method.match(/([^=?]+)([=?])?/)
      index = Regexp.last_match[1].to_sym
      if Regexp.last_match[2] == '='
        @attr[index] = args[0]
      elsif Regexp.last_match[2] == '?'
        !@attr[index].nil?
      else
        @attr[index]
      end
    else
      super
    end
  end

  def attributes
    @attr
  end

  # Pushes this model to mage
  # Note that this always creates a new item.
  def push(current_person)
    res = Mage::ApiCall.call("/#{self.class.table_name.pluralize}/#{@@create_action}.json", current_person, { self.class.table_name.to_sym => attributes }, :post)
    self.class.parse_result(res, self) && true # Make boolean
  end

  # Returns all objects of this type
  def self.all
    return fake("#{name.downcase.gsub(/::/, '.')}.all") if Cashflow::Application.settings[:fake_mage]

    res = Mage::ApiCall.call("/#{table_name.pluralize}.json", nil, {}, :get)
    p = parse_result(res)
    if p
      return p.map do |item|
        new(item)
      end
    else
      false
    end
  end

  # Finds a model by id in mage and returns that model
  def self.find(id)
    res = Mage::ApiCall.call("/#{table_name.pluralize}/#{id}.json", nil, {}, :get)
    p = parse_result(res)
    if p
      new(p)
    else
      false
    end
  end

  def self.parse_result(res, item = nil)
    begin
      data = JSON.parse res.body
    rescue Exception
      puts "Error: Result not in json, #{$ERROR_INFO}: #{res.body}"
      item.errors = 'Result was not in json format' if item
      false
    end

    if res.is_a? Net::HTTPSuccess
      data
    else
      puts "Invalid return code (#{res.code})"
      item.errors = data['errors'] if item
      false
    end
  end

  # Returns the table name for this model in mage
  # Converts Mage::NameInCamelCase to name_in_camel_case
  # If this model is not in Mage namespace it returns false
  def self.table_name
    if name.match(/Mage::(.+)/)
      Regexp.last_match[1].underscore
    else
      false
    end
  end

  # Change which action is used to create in the api
  def self.create_action(val)
    @@create_action = val
  end

  # Add hook to run after initialization
  def self.after_initialize(method)
    @@after_initialize << method
  end

  # Add hook to run before initialization
  def self.before_initialize(method)
    @@before_initialize << method
  end

  # Fake a mage call
  def self.fake(key)
    yml = YAML.load(File.read(Rails.root.join('config', 'fake_mage.yml'), encoding: 'utf-8'))
    values = key.split('.').reduce(yml) { |memo, part| memo[part] }
    if values.is_a?(Array)
      values.map { |value| OpenStruct.new(value) }
    else
      OpenStruct.new(values)
    end
  end
end
