module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = '/algo/' + endpoint
      @query = {
        timeout: 300,
        stdout: false,
        output: 'default'
      }
    end

    def set_options(options_hash)
      @query_options.update(options_hash)
    end

    def set_timeout(timeout)
      @query_options[:timeout] = timeout.to_i
    end

    def enable_stdout
      @query_options[:stdout] = true
    end

    def pipe(input)
      content_type = case
        when input.kind_of?(String) && input.encoding == 'ASCII-8BIT'
          'application/octet-stream'
        when input.kind_of?(String)
          'text/plain'
        else
          'application/json'
        end

      headers = {
        'Content-Type' => content_type
      }

      response = Algorithmia::Http.new(@client).post(@endpoint, input, query: @query, headers: headers)
      Algorithmia::Response.new(response.parsed_response)
    end

    def pipe_json(input)
      response = Algorithmia::Http.new(@client).post(@endpoint, input, query: @query, headers: {})
      Algorithmia::Response.new(response.parsed_response)
    end
  end
end
