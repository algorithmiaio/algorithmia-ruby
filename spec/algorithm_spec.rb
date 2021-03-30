require 'spec_helper'
require 'digest'
require 'json'

describe Algorithmia::Algorithm do
  it 'can make json api call' do
    input = ["transformer", "terraforms", "retransform"]
    response = test_client.algo("WebPredict/ListAnagrams/0.1.0").pipe(input)
    expect(response.content_type).to eq('json')
    expect(response.result).to eq(["transformer","retransform"])
  end

  it 'can make raw json api call' do
    input = ["transformer", "terraforms", "retransform"].to_json
    response = test_client.algo("WebPredict/ListAnagrams/0.1.0").pipe_json(input)
    expect(response.content_type).to eq('json')
    expect(response.result).to eq(["transformer","retransform"])
  end

  it 'can make text api call' do
    input = "foo"
    response = test_client.algo("demo/hello").pipe(input)
    expect(response.content_type).to eq('text')
    expect(response.result).to eq("Hello foo")
  end

  it 'can make binary api call' do
    image_in = __dir__+'/data/theoffice.jpg'
    input = File.binread(image_in)
    response = test_client.algo("opencv/SmartThumbnail/0.1.14").pipe(input)

    expected_sha = "1e8042669864e34a65ba05b1c457e24aab7184dd5990c9377791e37890ac8760"
    expect(response.content_type).to eq('binary')
    expect(response.result.encoding).to eq(Encoding::ASCII_8BIT)
    expect(Digest::SHA256.hexdigest(response.result)).to eq(expected_sha)
  end

  # it 'can set timeout' do
  #   algo = test_client.algo("kenny/sleep").set(timeout: 1)
  #   expect{ algo.pipe(2) }.to raise_error(Algorithmia::Errors::AlgorithmError)
  # end

  it 'can get an Algorithm object from this client' do
    result = test_client.get_algo("jakemuntarsi", "Hello")
    expect(result.response["name"]).to eq('Hello')
    expect(result.response["resource_type"]).to eq('algorithm')
  end

  it 'it list algorithm versions from this client' do
    result = test_client.get_algo_versions("jakemuntarsi", "Hello", nil, nil, nil, nil)
    expect(result.instance_variable_get(:@response)['results'].size).to eq(2)
    expect(result.instance_variable_get(:@response)['results'][1]["name"]).to eq('Hello')
  end

  it 'it list algorithm builds from this client' do
    result = test_client.get_algo_builds("jakemuntarsi", "Hello", nil, nil)
    expect(result.instance_variable_get(:@response)['results'].size).to eq(2)
  end

  it 'it Get build logs for an Algorithm object from this client' do
    result = test_client.get_algo_build_logs("jakemuntarsi", "Hello", '2fb99aaa-9634-487f-b6bd-22d55c183b43')
    expect(result.instance_variable_get(:@response)['logs']).to be_truthy
  end

  it 'it Delete an Algorithm from this client' do
    algo_name = create_test_algo
    result = test_client.delete_algo("jakemuntarsi", algo_name)
    expect(result.instance_variable_get(:@response)).to be_nil
  end

  it 'it Get Algorithm SCM Status from this client' do
    result = test_client.get_scm_status("jakemuntarsi", "Hello")
    expect(result.response["scm_connection_status"]).to eq('active')
  end

  it 'it Creates an Organization from this client' do
    time_now = Time.now.to_i
    org_name = "MyOrg#{time_now}"
    organization = OpenStruct.new(org_name: org_name,
                              org_label: "myLabel",
                              org_contact_name: "some owner",
                              org_email: "#{org_name}@algo.com",
                              org_url: "https://#{org_name}algo.com",
                              external_id: "ext_#{time_now}",
                              type_id: "basic")

    result = test_admin.create_organization(organization.to_h.to_json)
    expect(result.response["org_name"]).to eq(org_name)
    expect(result.response["org_label"]).to eq("myLabel")
    expect(result.response["org_contact_name"]).to eq("some owner")
    expect(result.response["org_email"]).to eq("#{org_name}@algo.com")
    expect(result.response["org_url"]).to eq("https://#{org_name}algo.com")
    expect(result.response["external_id"]).to eq("ext_#{time_now}")
    destroy_test_org org_name
  end

  it 'it Get an Organization from this client' do
    org_name = "MyOrg#{Time.now.to_i}"
    create_test_org org_name
    sleep(5)
    result = test_admin.get_organization org_name
    expect(result.response["org_name"]).to eq(org_name)
    destroy_test_org org_name
  end

  it 'it Updates an Organization from this client' do
    time_now = Time.now.to_i
    org_name = "MyOrg#{time_now}"
    organization = create_test_org(org_name).response
    organization["org_label"] = "MyOrgLabel#{time_now}"
    organization["type_id"] = "legacy"
    organization["org_contact_name"] = "NewContactName#{time_now}"
    test_admin.update_organization(org_name, organization.to_json)
    sleep(5)
    result = test_admin.get_organization org_name
    expect(result.response["org_name"]).to eq(org_name)
    expect(result.response["org_label"]).to eq("MyOrgLabel#{time_now}")
    expect(result.response["org_contact_name"]).to eq("NewContactName#{time_now}")
    destroy_test_org org_name
  end

  #it 'it Revoke an Algorithm SCM status from this client' do
  #  result = test_client.revoke_scm_status( "internal")
  #  expect(result.response["scm_connection_status"]).to eq('active')
  #end

end
