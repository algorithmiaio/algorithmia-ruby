require 'spec_helper'

describe Algorithmia do
  it 'has a version number' do
    expect(Algorithmia::VERSION).not_to be nil
  end
end

describe Algorithmia::Client do

  it 'must include httparty methods' do
    expect(Algorithmia::Client).to include(HTTParty)
  end

  it 'must have the base url set to Algorithmia API endpoint' do
    expect(Algorithmia::Client.base_uri).to eq('https://api.algorithmia.com/v1')
  end
end
