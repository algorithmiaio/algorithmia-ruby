require 'spec_helper'

describe Algorithmia do
  it 'has a version number' do
    expect(Algorithmia::VERSION).not_to be nil
  end
end

describe Algorithmia::Client do

  it 'sets the base url set to Algorithmia API endpoint' do
    expect(Algorithmia::Requester.base_uri).to end_with("algorithmia.com")
  end

end
