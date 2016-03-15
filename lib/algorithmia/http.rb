require 'httparty'

module Algorithmia
  class Client
    include HTTParty
    base_uri "https://api.algorithmia.com/v1/algo"
    format :json
    @user_agent = 'Algorithmia Ruby Client'

    private

    def self.get_http(endpoint, params = {})
      params = params.to_s unless params.is_a?(Hash)
      parse_output get(endpoint, body: params, headers: { "Authorization" => @api_key, "Content-Type" => "application/json", "User-Agent" => @user_agent })
    end

    def self.post_http(endpoint, params = {})
      params = params.to_s unless params.is_a?(Hash)
      parse_output post(endpoint, body: params, headers: { "Authorization" => @api_key, "Content-Type" => "application/json", "User-Agent" => @user_agent })
    end

    def self.parse_output(res)
      result = res.parsed_response

      if result.include?(:error)
        raise AlgorithmiaException.new(result[:error])
      end
      
      result

      #todo: rescue no method error, json parse, exception
    end
  end
end