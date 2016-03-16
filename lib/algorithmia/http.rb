require 'httparty'

module Algorithmia
  class Client
    include HTTParty
    base_uri "https://api.algorithmia.com/v1/algo"
    format :json

    private

    def self.get_http(endpoint, params = {})
      params = params.to_s unless params.is_a?(Hash)
      parse_output get(endpoint, body: params, headers: { "Authorization" => @api_key, "Content-Type" => "application/json" })
    end

    def self.post_http(endpoint, params = {})
      params = params.to_s unless params.is_a?(Hash)
      parse_output post(endpoint, body: params, headers: { "Authorization" => @api_key, "Content-Type" => "application/json" })
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
end