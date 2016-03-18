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
      response = @client.request_head(@url)
      case response.code
      when 200
        return true
      when 401
        raise AlgorithmiaUnauthorized, "The request you are making requires authorization. Please check that you have permissions & that you've set your API key."
      else
        return false
      end
    end

    def get
    end

    def put
    end

    def delete
    end

    def parent
    end

    def base_name
    end
  end
end