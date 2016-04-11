require 'bundler/setup'
Bundler.setup

require_relative '../lib/algorithmia.rb'

def test_client
    expect(ENV['ALGORITHMIA_API_KEY']).to_not be_nil
    client = Algorithmia.client(ENV['ALGORITHMIA_API_KEY']);
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end