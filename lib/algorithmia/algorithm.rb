module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = '/v1/algo/' + endpoint
      @query = {
        timeout: 300,
        stdout: false,
        output: 'default'
      }
    end

    def set_options(options_hash)
      @query.update(options_hash)
    end

    def set_timeout(timeout)
      @query[:timeout] = timeout.to_i
    end

    def enable_stdout
      @query[:stdout] = true
    end

    def pipe(input)
      content_type = case
        when input.kind_of?(String) && input.encoding == Encoding::ASCII_8BIT
          'application/octet-stream'
        when input.kind_of?(String)
          'text/plain'
        else
          'application/json'
        end

      headers = {
        'Content-Type' => content_type
      }

      client_timeout = (@query[:timeout] || 300) + 10
      response = Algorithmia::Requester.new(@client).post(@endpoint, input, query: @query, headers: headers, timeout: client_timeout)
      Algorithmia::Response.new(response.parsed_response, @query[:output])
    end

    def pipe_json(input)
      client_timeout = (@query[:timeout] || 300) + 10
      response = Algorithmia::Requester.new(@client).post(@endpoint, input, query: @query, headers: {}, timeout: client_timeout)
      Algorithmia::Response.new(response.parsed_response)
    end
  end
end
