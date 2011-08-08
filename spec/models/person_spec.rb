require 'spec_helper'

describe Person do
  before(:all) do
    @admin = Factory(:admin)
  end
  before(:each) do
    @person = Factory(:person)
  end
  
  it "should have a default role of \"\"" do
    @person = Person.new
    @person.role.should == ""
  end
  
  %w[first_name last_name email ugid login].each do |attribute|
    it "should be invalid without a #{attribute}" do
      @person.send("#{attribute}=", nil)
      @person.should be_invalid
      @person.errors.should_not be_nil
      @person.errors[attribute.to_sym].should_not be_empty
    end
  end

  %w[first_name last_name ugid login role].each do |attribute|
    it "should protect attribute #{attribute}" do
      attr_value = @person.send(attribute)
      @person.update_attributes({attribute.to_sym => "blubb"}).should be_true
      @person.send(attribute).should == attr_value
    end
  end
  
  it "should correctly sum the total of all debts" do
    # make sure it can count the total of one debt.
    d1 = Factory :debt, :person_id => @person.id
    @person.reload.total_debt_amount.should == d1.amount
    
    # ...and add the sum of two debts together
    d2 = Factory :debt, :person_id => @person.id
    @person.reload.total_debt_amount.should == (d1.amount + d2.amount)
    
    # ..and not count paid debts
    d2.versions.last.update_attribute(:whodunnit,@admin.id)

    d2.pay!
    @person.reload.total_debt_amount.should == d1.amount
    
    # also, do count bookkept debts, but not paid ones
    d1.keep!
    d3 = Factory :debt, :person_id => @person.id 
    @person.reload.total_debt_amount.should == (d1.amount + d3.amount)
    
    # if we cancel one debt, it should not be counted
    d3.versions.last.update_attribute(:whodunnit,@admin.id)
    d3.cancel!
    @person.reload.total_debt_amount.should == d1.amount
    
    # and when no unpaid, uncancelled debts remain, the total debt sum should be zero
    d1.versions.last.update_attribute(:whodunnit,@admin.id)
    d1.pay!
    @person.reload.total_debt_amount.should == 0
  end
  
  it "should corretly sum the total of all purchases" do
    p1 = Factory :purchase, :person_id => @person.id
    @person.reload.total_purchased_amount.should == p1.total
    
    p2 = Factory :purchase, :person_id => @person.id
    @person.reload.total_purchased_amount.should == (p1.total + p2.total)
    
    p1.cancel!
    @person.reload.total_purchased_amount.should == p2.total
    
    p2.confirm!
    p3 = Factory :purchase, :person_id => @person.id
    @person.reload.total_purchased_amount.should == (p2.total + p3.total)
    
    p2.edit!
    @person.reload.total_purchased_amount.should == (p2.total + p3.total)
    
    p2.confirm!
    p2.keep!
    @person.reload.total_purchased_amount.should == (p2.total + p3.total)
    
    p3.confirm!
    p3.pay!
    @person.reload.total_purchased_amount.should == (p2.total)
    
    p2.pay!
    @person.reload.total_purchased_amount.should == 0
  end
  
  it "should have a string representation matching its LDAP cn" do
    @person.cn.should == "#{@person.first_name} #{@person.last_name} (#{@person.login})"
    @person.to_s.should == @person.cn
  end

  # create an LDAP connection for these specs to wor
  describe "LDAP connection" do
    it "should correctly fetch information from LDAP" do
      begin
        # make this spec search by:
        # * first_name, last_name
        # * login
        # * ugid
        # * email
        local_config = YAML.load(File.read("#{Rails.root}/config/local.yml"))
        name_search_params  = {:first_name => local_config[:yourself][:first_name], :last_name => local_config[:yourself][:last_name]}
        email_search_params = {:email => local_config[:yourself][:email]}
        ugid  = {:ugid => local_config[:yourself][:ugid]}
        login_search_params = {:login => local_config[:yourself][:login]}

        Person.from_ldap(name_search_params).should_not be_nil 
        Person.from_ldap(email_search_params).should_not be_nil 
        Person.from_ldap(ugid).should_not be_nil 
        Person.from_ldap(login_search_params).should_not be_nil 
        
        # TODO: verify a few more things than just searching... like some things should return nil (ugid search of "azovwemzavwmdzvway" for instance)
      rescue Net::LDAP::LdapError => e
        pending "UNABLE TO CONNECT TO LDAP SERVER"
      end
      
    end
  
    it "should correctly create users from an LDAP search" do
      begin
        local_config = YAML.load(File.read("#{Rails.root}/config/local.yml"))
        Person.create_from_ldap(:ugid => local_config[:yourself][:ugid])
      rescue Net::LDAP::LdapError => e
        pending "UNABLE TO CONNECT TO LDAP SERVER"
      end
      
    end
  end
end
