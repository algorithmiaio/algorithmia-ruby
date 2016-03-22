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
      response = self.class.get(endpoint, headers: headers)
      check_for_errors(response)
      response
    end

    def post(endpoint, body, query: {}, headers: {})
      headers = merge_headers(headers)
      response = self.class.post(endpoint, body: body, query: query, headers: headers)
      check_for_errors(response)
      response
    end

    def put(endpoint, body, query: {}, headers: {})
      headers = merge_headers(headers)
      response = self.class.put(endpoint, body: body, query: query, headers: headers)
      check_for_errors(response)
      response
    end

    def head(endpoint)
      response = self.class.head(endpoint, headers: @default_headers)
      check_for_errors(response)
      response
    end

    def delete(endpoint)
      response = self.class.delete(endpoint, headers: @default_headers)
      check_for_errors(response)
      response
    end

    private

    def check_for_errors(response)
      if response.code < 200 || response.code >= 300
        raise Errors::UnknownError, "Got a #{response.code} from the API"
      end
    end

    def merge_headers(headers = {})
      @default_headers.merge(headers)
    end
  end
end
