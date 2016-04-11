require 'spec_helper'
require 'digest'

describe Algorithmia::DataFile do

  def empty_dir
    dir = test_client.dir("data://.my/rubytest")
    dir.delete(true) if dir.exists?
    expect(dir.exists?).to be false
    dir.create
    expect(dir.exists?).to be true
    dir
  end

  it 'can resolve parent uri' do
    dir = Algorithmia.dir("data://.my/rubytest/foo")
    expect(dir.parent.data_uri).to eq("data://.my/rubytest")
  end

  it 'can read/write a text file' do
    dir = empty_dir
    file = dir.file("foo")

    expect(file.exists?).to be false
    file.put("string contents")
    expect(file.exists?).to be true

    expect(file.get).to eq("string contents")
  end

  it 'can read/write a binary file' do
    dir = empty_dir
    file = dir.file("foo")

    path = __dir__+'/data/theoffice.jpg'
    bytes = File.binread(path)
    expected_sha = Digest::SHA256.hexdigest(bytes)

    expect(file.exists?).to be false
    file.put(bytes)
    expect(file.exists?).to be true
    expect(Digest::SHA256.hexdigest(file.get)).to eq(expected_sha)
  end

  it "can delete a file" do
    dir = empty_dir
    file = dir.file("foo")

    expect(file.exists?).to be false
    file.put("string contents")
    expect(file.exists?).to be true
    file.delete
    expect(file.exists?).to be false
  end
end
