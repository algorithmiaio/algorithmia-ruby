module Algorithmia
  class Client
    attr_reader :api_key
    attr_reader :api_address

    def initialize(api_key, api_address=nil)
      @api_key = api_key
      @api_address = api_address || ENV['ALGORITHMIA_API'] || "https://api.algorithmia.com"
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
