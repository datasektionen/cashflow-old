class Mage::Base
  @@create_action = "create"
  @@after_initialize=[]
  @@before_initialize=[]

  def initialize(attr={})
    @attr = {}
    @@before_initialize.each { |c| self.send(c) }
    attr.each do |key, val|
      @attr[key] = val
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
    Mage::ApiCall.call("/#{table_name.pluralize}/#{@create_action}",current_person,{self.table_name.to_sym=>attributes})
  end

protected
  def self.table_name
    if self.class.name.match /Mage::(.+)/
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
