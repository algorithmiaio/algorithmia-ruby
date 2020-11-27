require 'bundler/setup'
Bundler.setup

require_relative '../lib/algorithmia.rb'

def test_client
  expect(ENV['ALGORITHMIA_API_KEY']).to_not be_nil
  Algorithmia.client(ENV['ALGORITHMIA_API_KEY'])
end

def create_test_algo
  algo_name = "CreateAlgoTest#{Time.now.to_i}"
  payload = {"name":algo_name,"details":{"label":"CreateAlgoTest"},"settings":{"environment":"cpu","language":"java","licence":"ap1","network_access":"full","pipeline_enabled":true,"source_visibility":"open"}}.to_json
  headers = {
      'Content-Type' => 'application/json'
  }
  Algorithmia::Requester.new(test_client).post('/v1/algorithms/jakemuntarsi', payload, query: nil, headers: headers)
  algo_name
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end