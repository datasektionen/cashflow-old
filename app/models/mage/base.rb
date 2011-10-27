class Mage::Base
  @@create_action = "create"
  #@@update_action = "update"
  #@@destroy_action = "destroy"

  def initialize(attr={})
    @attr = attr
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

  def create_action(val)
    @@create_action = val
  end
end
