require 'bundler/setup'
Bundler.setup

require 'algorithmia'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end