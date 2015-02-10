filename = Rails.root + 'config/configuration.yml'
fail 'Missing config/configuration.yml' unless File.exist?(filename)
yaml = YAML.load_file(filename)
if yaml.key?(Rails.env)
  yaml = yaml['common'].merge(yaml[Rails.env] || {})
  settings = ActiveSupport::HashWithIndifferentAccess.new(yaml)
  Cashflow::Application.settings = settings
else
  fail "Missing settings for #{Rails.env} environment" unless Rails.env.test?
end
