module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = endpoint
      @query = {}
    end

    def set(options_hash)
      @query.update(options_hash)
      self
    end

    def pipe(input)
      client_timeout = (@query[:timeout] || 300) + 10
      response = Algorithmia::Requester.new(@client).post(@endpoint, input, query: @query, headers: {}, timeout: client_timeout)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def pipe_json(input)
      client_timeout = (@query[:timeout] || 300) + 10
      headers = {
        'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).post(@endpoint, input, query: @query, headers: headers, timeout: client_timeout)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def algo
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

  end
end
