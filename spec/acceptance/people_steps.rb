steps_for :people do
  step "a person with the \":role\" role" do |role|
    @person = Factory(role.to_sym)
  end

  step "my credentials should have been retrieved" do
    pending "not yet implemented" # express the regexp above with the code you wish you had
  end

  step "I should see a form for filling in my bank account information" do
    pending "not yet implemented"# express the regexp above with the code you wish you had
  end
end

