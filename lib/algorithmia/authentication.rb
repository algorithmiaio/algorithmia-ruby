module Algorithmia
  class Client

    def self.api_key
      @api_key
    end

    def self.api_key?
      not @api_key.nil?
    end

    def self.api_key=(api_key)
      if not api_key.is_a?(String) or api_key.to_s.empty?
        raise AlgorithmiaApiKeyEmpty.new('Looks like you forgot to provide your Algorithmia API key. Please set `Algorithmia::Client.api_key`.')
      end

      @api_key = api_key
    end
  end
end