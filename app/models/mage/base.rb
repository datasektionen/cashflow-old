class Mage::Base
  @@create_action = "create"
  @@after_initialize=[]
  @@before_initialize=[]

  def initialize(attr={})
    @attr = {}
    @@before_initialize.each { |c| self.send(c) }
    attr.each do |key, val|
      @attr[key.to_sym] = val
    end
    @@after_initialize.each { |c| call(c) }
  end

  def method_missing(method,*args)
    if method.match /([^=?]+)([=?])?/
      index = $1.to_sym
      if $2=="="
        @attr[index] = args[0]
      elsif $2=="?"
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
  def push(current_person)
    res = Mage::ApiCall.call("/#{table_name.pluralize}/#{@create_action}.json",current_person,{self.table_name.to_sym=>attributes}, :post)
    parse_result(res,self) && true # Make boolean
  end

  def self.all
    res = Mage::ApiCall.call("/#{table_name.pluralize}.json",nil,{}, :get)
    p = parse_result(res)
    if p
      return p.map do |item|
        self.new(item[table_name])
      end
    else
      false
    end 
  end

  def self.find(id)
    res = Mage::ApiCall.call("/#{table_name.pluralize}/#{id}.json", nil, {}, :get)
    p = parse_result(res)
    if p
      return self.new(p[table_name])
    else
        false
    end
  end

protected
  def self.parse_result(res,item=nil)
    begin
      data = JSON.parse res.body
    rescue Exception
      puts $!
      puts "Error: Result not in json"
      puts res.body
      item.errors = "Result was not in json format" if item
      return false
    end

    if res.kind_of? Net::HTTPSuccess
      return data
    else
      puts "Invalid return code (#{res.code})"
      errors = data["errors"] if item
      return false
    end
  end

  def self.table_name
    if name.match /Mage::(.+)/
      return $1.underscore
    else
      false
    end
  end

  def self.create_action(val)
    @@create_action = val
  end

  def self.after_initialize(method)
    @@after_initialize << method
  end

  def self.before_initialize(method)
    @@before_initialize << method
  end
end
