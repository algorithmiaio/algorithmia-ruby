require 'httparty'

module Algorithmia
  class Requester
    include HTTParty
    base_uri "https://api.algorithmia.com/v1"

    def initialize(client)
      @client = client
      @default_headers = {
        'Authorization' => @client.api_key || '',
        'Content-Type' => 'application/json',
        'User-Agent' => 'Algorithmia Ruby Client'
      }
    end

    def get(endpoint, query: {}, headers: {})
      headers = merge_headers(headers)
      response = self.class.get(endpoint, query: query, headers: headers)
      check_for_errors(response)
      response
    end

    def post(endpoint, body, query: {}, headers: {})
      headers = merge_headers(headers)

      if headers['Content-Type'] == 'application/json'
        body = body.to_json
      end

      response = self.class.post(endpoint, body: body, query: query, headers: headers)
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
      response = self.class.head(endpoint, headers: @default_headers)
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
      return if response.code >= 200 && response.code < 300

      case response.code
      when 401
        raise Errors::UnauthorizedError.new("The request you are making requires authorization. Please check that you have permissions & that you've set your API key.", response)
      when 400
        parse_error_message(response)
      when 404
        raise Errors::NotFoundError.new("The URI requested is invalid or the resource requested does not exist.", response)
      when 500
        raise Errors::InternalServerError.new("Whoops! Something is broken.", response)
      else
        raise Errors::UnknownError.new("The error you encountered returned the message: #{response["error"]["message"]} with stacktrace: #{error["stacktrace"]}", response)
      end
    end

    def parse_error_message(response)
      error = response['error']

      case error["message"]
      when 'authorization required'
        raise Errors::ApiKeyInvalidError.new("The API key you sent is invalid! Please set `Algorithmia::Client.api_key` with the key provided with your account.", response)
      when 'Failed to parse input, input did not parse as valid json'
        raise Errors::JsonParseError.new("Unable to parse the input. Please make sure it matches the expected input of the algorithm and can be parsed into JSON.", response)
      else
        if error["stacktrace"].nil?
          raise Errors::UnknownError.new("The error you encountered returned the message: #{error["message"]}", response)
        else
          raise Errors::UnknownError.new("The error you encountered returned the message: #{error["message"]} with stacktrace: #{error["stacktrace"]}", response)
        end
      end
    end

    def merge_headers(headers = {})
      @default_headers.merge(headers)
    end
  end
end
