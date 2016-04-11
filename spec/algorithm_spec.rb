require 'spec_helper'
require 'digest'

describe Algorithmia::Algorithm do
  def client
    expect(ENV['ALGORITHMIA_API_KEY']).to_not be_nil
    client = Algorithmia.client(ENV['ALGORITHMIA_API_KEY']);
  end

  it 'can make json api call' do
    input = 5
    response = client.algo("docs/JavaAddOne").pipe(input)
    expect(response.content_type).to eq('json')
    expect(response.result).to eq(6)
  end

  it 'can make text api call' do
    input = "foo"
    response = client.algo("demo/hello").pipe(input)
    expect(response.content_type).to eq('text')
    expect(response.result).to eq("Hello foo")
  end

  it 'can make binary api call' do
    image_in = __dir__+'/data/theoffice.jpg'
    image_out = __dir__+'/data/theoffice_thumb.png'
    input = File.binread(image_in)
    expected_sha = "1e8042669864e34a65ba05b1c457e24aab7184dd5990c9377791e37890ac8760"

    response = client.algo("opencv/SmartThumbnail/0.1.14").pipe(input)
    expect(response.content_type).to eq('binary')
    expect(response.result.encoding).to eq(Encoding::ASCII_8BIT)
    expect(Digest::SHA256.hexdigest(response.result)).to eq(expected_sha)
  end

end
