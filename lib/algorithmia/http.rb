require 'httparty'

module Algorithmia
  class Client
    include HTTParty
    base_uri "https://api.algorithmia.com/v1"

    private

    def self.set_headers(headers = {})
      @headers = {
        'Authorization': @api_key,
        'Content-Type': 'application/json',
        'User-Agent': 'Algorithmia Ruby Client'
      }

      @headers.tap { |h| h.merge!(headers) }
    end

    def self.get_http(endpoint, headers, input, options)
      input = input.to_s unless input.is_a?(Hash)
      set_headers(headers)

      parse_output get(endpoint, body: params, headers: @headers)
    end

    def self.post_http(endpoint, headers, input, options)
      input = input.to_s unless input.is_a?(Hash)
      set_headers(headers)

      parse_output post(endpoint, body: input, headers: @headers, query: options)
    end

    def self.request_head(endpoint)
      set_headers
      response = head(endpoint, headers: @headers)
    end

    def self.delete_file(endpoint)
      set_headers
      response = delete(endpoint, headers: @headers)
    end

    def self.parse_output(res)
      result = res.parsed_response

      if result.include?("error")
        Algorithmia::AlgorithmiaException.new(result)
      else
        Algorithmia::Response.new(result)
      end
    end

  end
end