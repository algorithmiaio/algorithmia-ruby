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
      @headers = {}
      check_content_type(input)
      @client.post_http("/#{@endpoint}", @headers, input, @query_options)
    end

    def pipeJson(input)
      @headers = {'Content-Type': 'application/json'}
      @client.post_http("/#{@endpoint}", @headers, input, @query_options)
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
