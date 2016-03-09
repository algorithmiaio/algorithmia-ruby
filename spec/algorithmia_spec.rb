require 'spec_helper'

describe Algorithmia do
  it 'has a version number' do
    expect(Algorithmia::VERSION).not_to be nil
  end
end

describe Algorithmia::Client do

  it 'includes httparty methods' do
    expect(Algorithmia::Client).to include(HTTParty)
  end

  it 'sets the base url set to Algorithmia API endpoint' do
    expect(Algorithmia::Client.base_uri).to eq('https://api.algorithmia.com/v1')
  end

  it 'has an API key' do
  end

  it 'raises an error if the API key is not a string' do
  end

  it 'raises an error if the API key is empty' do
  end
  
end
