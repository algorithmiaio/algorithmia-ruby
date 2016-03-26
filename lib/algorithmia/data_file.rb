require 'tempfile'

module Algorithmia
  class DataFile < DataObject

    def exists?
      Algorithmia::Http.new(@client).head(@url)
      true
    end

    def get_file
      response = get_string

      tempfile = Tempfile.open(File.basename(@url)) do |f|
        f.write response
        f
      end

      File.new(tempfile.path)
    end

    def get_string
      Algorithmia::Http.new(@client).get(@url).body
    end

    def get_bytes
      get_string.bytes
    end

    def put(string)
      Algorithmia::Http.new(@client).put(@url, string)
    end

    alias_method :put_json, :put

    def put_file(file_path)
      file = File.read(file_path)
      Algorithmia::Http.new(@client).put(@url, file)
    end

    def delete
      Algorithmia::Http.new(@client).delete(@url)
      true
    end
  end
end
