module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = endpoint
    end

    def pipe(input)
      @headers = {}
      check_content_type(input)
      @client.post_http("/#{@endpoint}", @headers, input.to_json)
    end

    def pipeJson(input)
      #Same as .pipe(String) except that the request Content-Type is application/json.
      # Examples:
      # response = algo.pipeJson("[\"foo\", \"bar\"]")
    end

    def self.set_options(options_hash)
      self.query_params = {'timeout': @timeout, 'stdout': @stdout }
      self.output_type = @output
      self.query_parameters.update(query_parameters)
    end

    private

    def check_content_type(input)
      case
      when input.kind_of?(String) && input.encoding == 'ASCII-8BIT'
        @headers['Content-Type'] = 'application/octet-stream'
      when input.kind_of?(String)
        @headers['Content-Type'] = 'text/plain'
      else
        @headers['Content-Type'] = 'application/json'
      end
    end

  end
end
