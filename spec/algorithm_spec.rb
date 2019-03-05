require 'spec_helper'
require 'digest'

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

end
