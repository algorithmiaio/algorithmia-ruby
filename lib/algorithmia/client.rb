module Algorithmia
  class Client
    attr_reader :api_key
    attr_reader :api_address

    def initialize(api_key, api_address=nil)
      @api_key = api_key
      @api_address = api_address || ENV['ALGORITHMIA_API'] || "https://api.algorithmia.com"
    end

    def algo(endpoint, path = '/v1/algo/')
      Algorithmia::Algorithm.new(self, endpoint.prepend(path))
    end

    def get_algo(user_name, algo_name)
      algo(user_name.concat('/').concat(algo_name), '/v1/algorithms/').algo
    end


    def file(endpoint)
      Algorithmia::DataFile.new(self, endpoint)
    end

    def dir(endpoint)
      Algorithmia::DataDirectory.new(self, endpoint)
    end
  end
end
