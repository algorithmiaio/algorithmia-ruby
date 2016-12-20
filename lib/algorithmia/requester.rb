require 'httparty'

module Algorithmia
  class Requester
    include HTTParty

    def initialize(client)
      self.class.base_uri client.api_address
      @client = client
      @default_headers = {
        'Content-Type' => 'application/json',
        'User-Agent' => 'Algorithmia Ruby Client'
      }
      unless @client.api_key.nil?
        @default_headers['Authorization'] = @client.api_key
      end
    end

    def get(endpoint, query: {}, headers: {})
      headers = merge_headers(headers)
      headers.delete('Content-Type')   # No content, can break request parsing
      response = self.class.get(endpoint, query: query, headers: headers)
      check_for_errors(response)
      response
    end

    def post(endpoint, body, query: {}, headers: {}, timeout: 60)
      headers = merge_headers(headers)

      if headers['Content-Type'] == 'application/json'
        body = body.to_json
      end

      response = self.class.post(endpoint, body: body, query: query, headers: headers, timeout: timeout)
      check_for_errors(response)
      response
    end

    def put(endpoint, body, query: {}, headers: {})
      headers = merge_headers(headers)

      if headers['Content-Type'] == 'application/json'
        body = body.to_json
      end

      response = self.class.put(endpoint, body: body, query: query, headers: headers)
      check_for_errors(response)
      response
    end

    def head(endpoint)
      headers = merge_headers({})
      headers.delete('Content-Type')   # No content, can break request parsing
      response = self.class.head(endpoint, headers: headers)
      check_for_errors(response)
      response
    end

    def delete(endpoint, query: {})
      response = self.class.delete(endpoint, query: query, headers: @default_headers)
      check_for_errors(response)
      response
    end

    private

    def check_for_errors(response)
      if response.code >= 200 && response.code < 300
        if response.is_a?(Hash) and response['error']
          error = response['error']
          raise Errors::AlgorithmError.new(error["message"], response, error["stacktrace"])
        end
        return
      end

      message = response.dig("error", "message") if response.is_a?(Hash)

      case response.code
      when 401
        message ||= "The request you are making requires authorization. Please check that you have permissions & that you've set your API key."
        raise Errors::UnauthorizedError.new(message, response)
      when 404
        message ||= "The URI requested is invalid or the resource requested does not exist."
        raise Errors::NotFoundError.new(message, response)
      when 500..599
        message ||= "Whoops! Something is broken."
        raise Errors::InternalServerError.new(message, response)
      else
        message ||= "#{response.code} - an unknown error occurred"
        raise Errors::ApiError.new(message, response)
      end
    end

    def merge_headers(headers = {})
      @default_headers.merge(headers)
    end
  end
end
