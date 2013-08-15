# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Rails.application.config.secret_token = ENV["SECRET_TOKEN"] ||
  '09a55b6ac022b75d133d9111e389542ba7f36b18c71e1eea303e7cf1dc81fa6ee59e5f6d0e7b68770927737c5bf2e8ffc4f43858d381f0e90ef027041ab8ba23'
