module Algorithmia
  class Client
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def algo(endpoint)
      Algorithmia::Algorithm.new(self, endpoint)
    end

    def file(endpoint)
      Algorithmia::DataFile.new(self, endpoint)
    end

    def dir(endpoint)
      Algorithmia::DataDirectory.new(self, endpoint)
    end
  end
end
