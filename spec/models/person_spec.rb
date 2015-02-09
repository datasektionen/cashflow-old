require "spec_helper"

describe Person do
  before(:all) do
    @admin = create(:admin)
  end
  before(:each) do
    @person = create(:person)
  end

  it "should have a default role of ''" do
    @person = Person.new
    expect(@person.role).to eq("")
  end

  %w(first_name last_name email ugid login).each do |attribute|
    it "should be invalid without a #{attribute}" do
      @person.send("#{attribute}=", nil)
      expect(@person).to be_invalid
      expect(@person.errors).not_to be_nil
      expect(@person.errors[attribute.to_sym]).not_to be_empty
    end
  end

  %w(first_name last_name ugid login role).each do |attribute|
    it "should protect attribute #{attribute}" do
      attr_value = @person.send(attribute)
      expect(@person.update_attributes(attribute.to_sym => "foo")).to be_truthy
      expect(@person.send(attribute)).to eq(attr_value)
    end
  end

  it "should corretly sum the total of all purchases" do
    p1 = create(:purchase, person_id: @person.id)
    expect(@person.reload.total_purchased_amount).to eq(p1.total)

    p2 = create(:purchase, person_id: @person.id)
    expect(@person.reload.total_purchased_amount).to eq(p1.total + p2.total)

    p1.cancel!
    expect(@person.reload.total_purchased_amount).to eq(p2.total)

    p2.confirm!
    p3 = create(:purchase, person_id: @person.id)
    expect(@person.reload.total_purchased_amount).to eq(p2.total + p3.total)

    p2.edit!
    expect(@person.reload.total_purchased_amount).to eq(p2.total + p3.total)

    p2.confirm!
    p2.keep!
    expect(@person.reload.total_purchased_amount).to eq(p2.total + p3.total)

    p3.confirm!
    p3.pay!
    expect(@person.reload.total_purchased_amount).to eq(p2.total)

    p2.pay!
    expect(@person.reload.total_purchased_amount).to eq(0)
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
        name_search_params  = {
          first_name: local_config[:yourself][:first_name],
          last_name: local_config[:yourself][:last_name]
        }
        email_search_params = { email: local_config[:yourself][:email] }
        ugid  = { ugid: local_config[:yourself][:ugid] }
        login_search_params = { login: local_config[:yourself][:login] }

        expect(Person.from_ldap(name_search_params)).not_to be_nil
        expect(Person.from_ldap(email_search_params)).not_to be_nil
        expect(Person.from_ldap(ugid)).not_to be_nil
        expect(Person.from_ldap(login_search_params)).not_to be_nil

        # TODO: verify a few more things than just searching...
        # like some things should return nil
        # (ugid search of "azovwemzavwmdzvway" for instance)
      rescue Net::LDAP::Error => _e
        skip "UNABLE TO CONNECT TO LDAP SERVER"
      end
    end

    it "should correctly create users from an LDAP search" do
      begin
        local_config = YAML.load(File.read("#{Rails.root}/config/local.yml"))
        Person.create_from_ldap(ugid: local_config[:yourself][:ugid])
      rescue Net::LDAP::Error => _e
        skip "UNABLE TO CONNECT TO LDAP SERVER"
      end
    end
  end
end
