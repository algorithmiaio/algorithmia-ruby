require 'tempfile'

module Algorithmia
  class DataFile < DataObject

    def exists?
      Algorithmia::Requester.new(@client).head(@url)
      true
    rescue Errors::NotFoundError
      false
    end

    def get_file
      response = get

      tempfile = Tempfile.open(File.basename(@url)) do |f|
        f.write response
        f
      end

      File.new(tempfile.path)
    end

    def get
      Algorithmia::Requester.new(@client).get(@url).body
    end

    def put(data)
      Algorithmia::Requester.new(@client).put(@url, data, headers: {})
    end

    alias_method :put_json, :put

    def put_file(file_path)
      data = File.binread(file_path)
      put(data)
    end

    def delete
      Algorithmia::Requester.new(@client).delete(@url)
      true
    end
  end
end
