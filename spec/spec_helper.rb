require 'bundler/setup'
Bundler.setup

require_relative '../lib/algorithmia.rb'

def test_client
  expect(ENV['ALGORITHMIA_API_KEY']).to_not be_nil
  Algorithmia.client(ENV['ALGORITHMIA_API_KEY'])
end

def test_admin
  expect(ENV['ALGORITHMIA_ADMIN_API_KEY']).to_not be_nil
  Algorithmia.client(ENV['ALGORITHMIA_ADMIN_API_KEY'], ENV['ALGORITHMIA_ADMIN_API'])
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

def create_test_org(org_name)
  timestamp = Time.now.to_i
  organization = OpenStruct.new(org_name: org_name,
                                org_label: "myLabel",
                                org_contact_name: "some owner",
                                org_email: "#{org_name}_#{timestamp}@algo.com",
                                org_url: "https://algorithmia.com",
                                external_id: "ext_#{timestamp}",
                                type_id: "basic",
                                resource_type: "organization")
  test_admin.create_organization(organization.to_h.to_json)
end

def destroy_test_org (org_name)
  test_admin.delete_organization(org_name)
end

RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
