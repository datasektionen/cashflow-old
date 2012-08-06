set :deploy_to, "#{deploy_to}/#{stage}"

set :branch do
  default_tag = "master"
  tag = Capistrano::CLI.ui.ask "What tag/branch do you want to deploy? [#{default_tag}] "
  tag = default_tag if tag.empty?
  tag
end
