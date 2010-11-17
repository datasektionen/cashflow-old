class Person < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'ugid'
  end

  ROLES = {"Kassör" => "cashier", "Administratör" => "admin"}

  validates_presence_of :first_name, :last_name, :login, :email, :ugid
  validates :email, :email => true
  
  attr_accessible :email, :bank_clearing_number, :bank_account_number
  attr_accessor :bank_name
  
  has_many :debts, :dependent => :restrict
  has_many :purchases, :dependent => :restrict
  
  # String representation of a user.
  # Basically the same as the cn column in the LDAP server, that is:
  # "Firstname Lastname (username)"
  def to_s
    cn
  end
  
  def cn
    "%s %s (%s)" % [first_name, last_name, login]
  end
  
  def name
    "%s %s" % [first_name, last_name]
  end
  
  def bank_name
    # TODO: parse from clearing number
  end
  
  def total_debt_amount
    debts.unpaid.inject(0) {|sum,x| sum += x.amount }.to_f
  end
  
  def total_purchased_amount
    purchases.unpaid.inject(0) {|sum,x| sum += x.total}.to_f
  end
  
  # search KTH's LDAP server for a user.
  # This method will return a new Person object if it finds any information from the LDAP server.
  # The options hash should contain search filters.
  # The following filters are allowed:
  # * first_name
  # * last_name
  # * ugid
  # * login
  # * email
  # 
  # If supplied with more than one filter, the search will be more specific (first_name=foo & last_name=bar).
  # 
  # Make sure to supply it with specific filters, since it will only return the first user it finds.
  def self.from_ldap(options = {})
    filters = {:givenName   => options[:first_name],
               :sn          => options[:last_name],
               :ugKthid     => options[:ugid],
               :ugusername  => options[:login],
               :mail        => options[:email]}
    
    filters.reject! {|k,v| v.blank? }
    
    # if we don't have any filters, we won't have to search
    return nil if filters.empty?
    # map filters to proper ldap filters,
    # and join them into a big query
    filter = filters.map do |k,v|
      Net::LDAP::Filter.eq(k,v)
    end.inject {|x,y| x&y }
    
    ldap = Net::LDAP.new( :host => Cashflow::Application.settings["ldap_host"], 
                          :base => Cashflow::Application.settings["ldap_basedn"], 
                          :port => Cashflow::Application.settings["ldap_port"])
    
    ldap.search(:filter => filter) do |user|
      person = new()
      person.first_name = user.givenName.first
      person.last_name = user.sn.first
      person.login = user.ugusername.first
      person.ugid = user.ugkthid.first
      person.email = user.mail.first
      return person
    end
    return nil
  end
  
  # Utilize Person.from_ldap and save the resulting user.
  # This is for example used by PersonSessionController in order to make sure that all logged in CAS users have a corresponding Person-object.
  def self.create_from_ldap(options)
    if p = from_ldap(options)
      p.save
    else
      nil
    end
  end
end
