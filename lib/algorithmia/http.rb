require 'httparty'

module Algorithmia
  class Http
    include HTTParty
    base_uri "https://api.algorithmia.com/v1"

    def initialize(client)
      @client = client
      @default_headers = {
        'Authorization': @client.api_key || '',
        'Content-Type': 'application/json',
        'User-Agent': 'Algorithmia Ruby Client'
      }
    end

    def get(endpoint, headers: {})
      headers = merge_headers(headers)
      self.class.get(endpoint, headers: headers)
    end

    def post(endpoint, body, query: {}, headers: {})
      headers = merge_headers(headers)
      self.class.post(endpoint, body: body, query: query, headers: headers)
    end

    def head(endpoint)
      self.class.head(endpoint, headers: @default_headers)
    end

    def delete(endpoint)
      self.class.delete(endpoint, headers: @default_headers)
    end

    private

    def merge_headers(headers = {})
      @default_headers.merge(headers)
    end
  end
end
