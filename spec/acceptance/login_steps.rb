steps_for :login do
  step "I am admin" do
    @person ||= Factory :person
    @person.role = 'admin'
    @person.save
    @person.reload
  end

  step "I am logged in" do
    unless @person
      step 'a person with the "person" role'
    end
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:cas, {uid: @person.ugid})

    visit(new_session_path)
  end

  step "I am logged in as the person" do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:cas, {:uid => @person.ugid })

    visit(new_session_path)
  end

  step "I am not authenticated" do
    visit('/sign_out')
  end
end

