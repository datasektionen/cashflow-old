class Person < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'ugid'
  end
  
  validates_presence_of :first_name, :last_name, :login, :email, :ugid
  attr_accessible :email
  
  
  def to_s
    "%s %s" % [first_name, last_name]
  end
  
  # FIXME: write this method
  # http://www.liveandcode.com/2009/08/30/ldap-pass-through-authentication-with-authlogic-and-activeldap/
  # rewrite AuthlogicCas::Session#persist_by_cas to use this method for finding people.
  # load ldap configs from Rails.root / config / ldap.yml using an OpenStruct or something...
  def find_or_create_from_ldap(kth_ugid)
    # if we don't already have a user with this ugid, we'll need to import his/her credentials from LDAP
    unless person = find_by_ugid(kth_ugid)
      person = Person.new(:ugid => kth_ugid)
      # do magic ldap stuffsies
      person.save
    end
    return person
  end
end
