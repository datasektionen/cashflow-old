module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /^the home\s?page$/
      '/'
    when /^the budget page for last year$/
      budget_path(id: Time.now.year - 1)
    when /^the budget page$/
      budget_index_path

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = Regexp.last_match[1].split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
