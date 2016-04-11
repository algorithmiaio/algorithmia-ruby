require 'bundler/setup'
Bundler.setup

require_relative '../lib/algorithmia.rb'

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end