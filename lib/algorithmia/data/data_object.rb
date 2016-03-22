module Algorithmia
  class DataObject

    def initialize(client, data_uri)
      @client = client
      @data_uri = data_uri
    end

    def basename
      File.basename(@url)
    end
  end
end
