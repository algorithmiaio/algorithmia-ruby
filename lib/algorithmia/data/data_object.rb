module Algorithmia
  class DataObject

    def initialize(client, data_uri)
      @client = client
      @data_uri = data_uri
    end

    def is_file?
      self.is_a? DataFile
    end

    def is_dir?
      self.is_a? DataDirectory
    end
  end
end