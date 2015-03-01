# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  config.secret_key = Cashflow::Application.settings["devise_secret_key"]

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require "devise/orm/active_record"
  require "net/https"

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 10. If
  # using other encryptors, it sets how many times you want the password
  # re-encrypted.
  config.stretches = 10

  # Setup a pepper to generate the encrypted password.
  config.pepper = '2e125486baf90f40fae080ef914a565ac8ca1b5877cadb4e26b6d6ba8fb1968d5ff9eebcc0aa46128da5136c853feb3249ef9c4d44d9c78e55bcfc530a2726e7'

  # ==> Warden configuration
  # If you want to use other strategies, that are not (yet) supported by Devise,
  # you can configure them inside the config.warden block. The example below
  # allows you to setup OAuth, using http://github.com/roman/warden_oauth
  #
  # config.warden do |manager|
  #   manager.oauth(:twitter) do |twitter|
  #     twitter.consumer_secret = <YOUR CONSUMER SECRET>
  #     twitter.consumer_key  = <YOUR CONSUMER KEY>
  #     twitter.options :site => 'http://twitter.com'
  #   end
  #   manager.default_strategies(:scope => :user).unshift :twitter_oauth
  # end
  #
  # config.cas_base_url = "https://login.kth.se"
  config.omniauth :cas, url: "https://login.kth.se"
  if Cashflow::Application.settings["enable_developer_login_strategy"]
    config.omniauth :developer, fields: [:ugid], uid_field: :ugid
  end
end
