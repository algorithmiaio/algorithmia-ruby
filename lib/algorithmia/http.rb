require 'httparty'
require 'tempfile'

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

    def get(endpoint, input, options, headers: {})
      input = input.to_s unless input.is_a?(Hash)
      headers = merge_headers(headers)
      parse_output self.class.get(endpoint, body: input, headers: headers)
    end

    def post(endpoint, input, options, headers: {})
      input = input.to_s unless input.is_a?(Hash)
      headers = merge_headers(headers)

      parse_output self.class.post(endpoint, body: input, headers: headers, query: options)
    end

    def head(endpoint)
      self.class.head(endpoint, headers: @default_headers)
    end

    def delete(endpoint)
      self.class.delete(endpoint, headers: @default_headers)
    end

    def get_string(endpoint)
      filename = File.basename(endpoint)
      self.class.get(endpoint, headers: @default_headers).parsed_response
    end

    def get_file(endpoint)
      response = get_string(endpoint)

      if response.include?("error")
        raise Errors.parse_error(result)
      end

      tempfile = Tempfile.open(filename) do |f|
        f.write response
        f
      end

      File.new(tempfile.path)
    end

    private

    def parse_output(res)
      result = res.parsed_response

      if result.include?("error")
        raise Errors.parse_error(result)
      end

      Algorithmia::Response.new(result)
    end

    def merge_headers(headers = {})
      @default_headers.merge(headers)
    end
  end
end
