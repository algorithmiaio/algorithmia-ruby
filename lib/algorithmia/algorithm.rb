module Algorithmia
  class Algorithm

    def initialize(client, endpoint)
      @client = client
      @endpoint = endpoint
    end

    def self.set_options(options_hash)
      self.query_params = {'timeout': @timeout, 'stdout': @stdout }
      self.output_type = @output
      self.query_parameters.update(query_parameters)
    end

    def pipe(input)
      @client.post_http("/#{@endpoint}", input.to_json)
    end
  end
end