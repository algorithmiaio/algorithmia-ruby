require 'spec_helper'
require 'digest'

describe Algorithmia::DataDirectory do

  def nonexistent_dir
    dir = test_client.dir("data://.my/rubytest")
    dir.delete(true) if dir.exists?
    expect(dir.exists?).to be false
    dir
  end

  it 'can resolve parent uri' do
    dir = Algorithmia.dir("data://.my/rubytest")
    expect(dir.parent.data_uri).to eq("data://.my")
  end

  it 'can resolve child uri' do
    dir = Algorithmia.dir("data://.my/rubytest")
    expect(dir.file("foo").data_uri).to eq("data://.my/rubytest/foo")
  end

  it 'can create/delete a directory' do
    dir = nonexistent_dir

    expect(dir.create).to be true
    expect(dir.exists?).to be true
    dir.delete
    expect(dir.exists?).to be false
  end

  it 'can put a file' do
    dir = nonexistent_dir
    expect(dir.create).to be true

    dir.put_file(__dir__+'/data/foo')
    file = dir.file('foo')
    expect(file.exists?).to be true
  end

  it 'does not delete dir with files' do
    dir = nonexistent_dir
    expect(dir.create).to be true

    dir.put_file(__dir__+'/data/foo')
    expect{dir.delete}.to raise_error(Algorithmia::Errors::UnknownError)
    expect(dir.exists?).to be true
  end

  it 'can force delete dir with files' do
    dir = nonexistent_dir
    expect(dir.create).to be true

    dir.put_file(__dir__+'/data/foo')
    dir.delete(true)
    expect(dir.exists?).to be false
  end

  it 'can list directory' do
    dir = nonexistent_dir
    expect(dir.create).to be true

    files = dir.each_file.map { |f| f.data_uri }
    expect(files.length).to eq(0)

    dir.file("foo").put("testdata")
    files = dir.each_file.map { |f| f.data_uri }
    expect(files.length).to eq(1)

    dir.file("bar").put("testdata")
    files = dir.each_file.map { |f| f.data_uri }
    expect(files.length).to eq(2)
    dir.each_file { |f|
        expect(f.get).to eq("testdata")
    }
  end

end
