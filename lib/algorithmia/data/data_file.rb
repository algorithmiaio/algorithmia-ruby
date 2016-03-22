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
      Algorithmia::Http.new(@client).get_file(@url)
    end

    def get_string
      Algorithmia::Http.new(@client).get_string(@url)
    end

    def get_bytes
      get_string.bytes
    end

    def put
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
    end
  end
end
