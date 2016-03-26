module Algorithmia
  class DataObject

    def initialize(client, data_uri)
      @client = client
      @data_uri = data_uri
      sanitize_data_uri
    end

    def basename
      File.basename(@url)
    end

    def sanitize_data_uri
      # TODO: ensure that the uri passed in starts with data://
      file_path = @data_uri.gsub('data://', '')
      @url = File.join('/data/', file_path)
    end

    def parent
      @client.dir(File.split(@data_uri).first)
    end
  end
end
