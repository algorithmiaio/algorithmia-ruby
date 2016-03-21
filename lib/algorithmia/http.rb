require 'httparty'

module Algorithmia

  class << self
    include HTTParty
    base_uri "https://api.algorithmia.com/v1"

    def set_headers(headers = {})
      @headers = {
        'Authorization': Algorithmia::Client.api_key ||= '',
        'Content-Type': 'application/json',
        'User-Agent': 'Algorithmia Ruby Client'
      }

      @headers.tap { |h| h.merge!(headers) }
    end

    def get_http(endpoint, headers, input, options)
      input = input.to_s unless input.is_a?(Hash)
      set_headers(headers)

      parse_output get(endpoint, body: params, headers: @headers)
    end

    def post_http(endpoint, headers, input, options)
      input = input.to_s unless input.is_a?(Hash)
      set_headers(headers)

      parse_output post(endpoint, body: input, headers: @headers, query: options)
    end

    def request_head(endpoint)
      set_headers
      response = head(endpoint, headers: @headers)
    end

    def delete_file(endpoint)
      set_headers
      response = delete(endpoint, headers: @headers)
    end

    def parse_output(res)
      result = res.parsed_response

      if result.include?("error")
        Algorithmia::AlgorithmiaException.new(result)
      else
        Algorithmia::Response.new(result)
      end
    end

  end
end