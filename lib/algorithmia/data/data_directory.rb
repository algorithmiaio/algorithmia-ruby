module Algorithmia
  class DataDirectory < DataObject

    def initialize(client, data_uri)
      super(client, data_uri)
    end

    def exists?
    end

  end
end