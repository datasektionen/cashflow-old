Airbrake.configure do |config|
  config.api_key     = '12b585b4310854fb0fb5e730ac642802'
  config.host        = 'errbit.datasektionen.se'
  config.port        = 80
  config.secure      = config.port == 443
end
