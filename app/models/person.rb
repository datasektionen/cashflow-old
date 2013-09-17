class Person < ActiveRecord::Base
  devise :omniauthable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  ROLES = ["treasurer", "admin", "accountant"]

  validates_presence_of :first_name, :last_name, :login, :email, :ugid
  validates :email, :email => true
  
  attr_accessible :email, :bank_clearing_number, :bank_account_number, :bank_name
  
  has_many :debts, :dependent => :restrict
  has_many :purchases, :dependent => :restrict

  has_friendly_id :login
  
  def to_s
    name
  end
  
  def cn
    "%s %s (%s)" % [first_name, last_name, login]
  end
  
  def name
    "%s %s" % [first_name, last_name]
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
    filters = {:givenName   => options[:first_name]||options['first_name'],
               :sn          => options[:last_name]||options['last_name'],
               :ugKthid     => options[:ugid]||options['ugid'],
               :ugUsername  => options[:login]||options['login'],
               :mail        => options[:email]||options['email']}
    
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
      person.login = user.ugUsername.first
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
      p
    else
      nil
    end
  end

  def is?(role)
    self.role == role.to_s
  end

  def self.find_for_cas_oath(access_token, signed_in_resource)
    return nil if access_token.blank?
    if person = Person.find_by_ugid(access_token["uid"])
      person
    else
      Person.create_from_ldap(:ugid => access_token["uid"])
    end
  end

  def to_json
    {
      :person => {
        :first_name => first_name,
        :last_name => last_name,
        :email => email,
        :ugid => ugid,
        :login => login
      }
    }.to_json
  end
end
