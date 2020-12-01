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

    def get_algo
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def delete_algo
      response = Algorithmia::Requester.new(@client).delete(@endpoint, query: @query)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def algo_versions(callable, limit, published, marker)
      headers = {
          'Content-Type' => 'application/json'
      }
      @query[:callable] = callable if callable
      @query[:limit] = limit if limit
      @query[published] = published if published
      @query[marker] = marker if marker
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def algo_builds(limit, marker)
      headers = {
          'Content-Type' => 'application/json'
      }
      @query[:limit] = limit if limit
      @query[marker] = marker if marker
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def algo_build_logs()
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def list_scms()
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def get_scm()
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def get_scm_status
      headers = {
          'Content-Type' => 'application/json'
      }
      response = Algorithmia::Requester.new(@client).get(@endpoint, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

  end
end
