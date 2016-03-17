require 'httparty'

module Algorithmia
  class Client
    include HTTParty
    base_uri "https://api.algorithmia.com/v1/algo"

    private

    def self.set_headers(headers)
      @headers = {
        'Authorization': @api_key,
        'Content-Type': 'application/json',
        'User-Agent': 'Algorithmia Ruby Client'
      }

      @headers.tap { |h| h.merge!(headers) }
    end

    def self.get_http(endpoint, params = {})
      params = params.to_s unless params.is_a?(Hash)
      parse_output get(endpoint, body: params, headers: { "Authorization" => @api_key, "Content-Type" => "application/json" })
    end

    def self.post_http(endpoint, headers, params = {})
      params = params.to_s unless params.is_a?(Hash)
      set_headers(headers)
      parse_output post(endpoint, body: params, headers: @headers)
    end

    def self.parse_output(res)
      result = res.parsed_response

      if result.include?("error")
        Algorithmia::AlgorithmiaException.new(result)
      else
        Algorithmia::Response.new(result)
      end

      rescue NoMethodError => e
        raise AlgorithmiaException.new(result)
      rescue JSON::ParserError => e
        raise AlgorithmiaException.new(e)
      rescue Exception => e
        raise AlgorithmiaException.new(e)
    end

  end
end