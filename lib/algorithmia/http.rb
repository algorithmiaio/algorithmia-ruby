require 'httparty'
require 'tempfile'

module Algorithmia
  include HTTParty
  base_uri "https://api.algorithmia.com/v1"

  class << self

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

      parse_output get(endpoint, body: input, headers: @headers)
    end

    def post_http(endpoint, headers, input, options)
      input = input.to_s unless input.is_a?(Hash)
      set_headers(headers)

      parse_output post(endpoint, body: input, headers: @headers, query: options)
    end

    def request_head(endpoint)
      set_headers
      head(endpoint, headers: @headers)
    end

    def delete_file(endpoint)
      set_headers
      delete(endpoint, headers: @headers)
    end

    def get_string(endpoint)
      set_headers
      filename = File.basename(endpoint)
      get(endpoint, headers: @headers).parsed_response
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

  end
end
