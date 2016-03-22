require 'tempfile'

module Algorithmia
  class DataFile < DataObject

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
      response = Algorithmia::Http.new(@client).head(@url)
      case response.code
      when 200
        return true
      when 401
        raise Errors::AlgorithmiaUnauthorized, "The request you are making requires authorization. Please check that you have permissions & that you've set your API key."
      else
        return false
      end
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
      response = Algorithmia::Http.new(@client).delete(@url)
      case response["result"]["deleted"]
      when 1
        return true
      else
        raise Errors::UnknownError, 'Request failed.'
      end
    end

    def parent
      # return DataDirectory
    end
  end
end
