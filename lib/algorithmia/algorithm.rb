module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = '/algo/' + endpoint
      @query_options = {
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

      response = Algorithmia::Http.new(@client).post(@endpoint, input, options: query_options, headers: headers)
      parse_output(response)
    end

    def pipe_json(input)
      response = Algorithmia::Http.new(@client).post(@endpoint, input, options: query_options, headers: {})
      parse_output(response)
    end

    private

    def parse_output(response)
      result = response.parsed_response

      if result.include?("error")
        raise Errors.parse_error(result)
      end

      Algorithmia::Response.new(result)
    end
  end
end
