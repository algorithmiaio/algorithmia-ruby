require 'uri'

module Algorithmia
  class DataDirectory < DataObject

    def initialize(client, data_uri)
      super(client, data_uri)
      validate_data_uri
    end

    def validate_data_uri
      # TODO: ensure that the uri passed in starts with data://
      file_path = @data_uri.gsub('data://', '')
      @url = '/data/' + file_path
    end

    def exists?
      Algorithmia::Http.new(@client).get(@url)
      true
    end

    def create
    end

    def delete
      # TODO: optional force
      Algorithmia::Http.new(@client).delete(@url, query: { force: :true })
    end

    def each
      return enum_for(:each) unless block_given?

      dir = Algorithmia::Http.new(@client).get(@url)

      files = (dir.parsed_response['files'] || []).map do |f|
        file(f['filename'])
      end

      dirs = (dir.parsed_response['folders'] || []).map do |f|
        @client.dir(URI.encode(@data_uri + f['name']))
      end

      (files + dirs).each do |f|
        yield f
      end
    end

    def each_file
      return enum_for(:each_file) unless block_given?

      dir = Algorithmia::Http.new(@client).get(@url)
      (dir.parsed_response['files'] || []).each do |f|
        yield file(f['filename'])
      end
    end

    def each_dir
      return enum_for(:each_dir) unless block_given?

      dir = Algorithmia::Http.new(@client).get(@url)
      (dir.parsed_response['folders'] || []).each do |f|
        yield @client.dir(URI.encode(@data_uri + f['name']))
      end
    end

    def file(file_name)
      # TODO: check if filename has leading slash; if not, add it
      @client.file(URI.encode(@data_uri + file_name))
    end

    def put_file(file_path)
      file = File.read(file_path)
      Algorithmia::Http.new(@client).put(@url, file)
    end

    def parent
      @client.dir(Pathname.new(@data_uri).parent.to_s)
    end
  end
end
