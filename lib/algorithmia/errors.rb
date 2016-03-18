module Algorithmia

  class AlgorithmiaException
    def initialize(error)
      @error = symbolize_keys(error["error"])
      parse_error
    end

    def parse_error
      case @error[:message]
      when 'authorization required'
        raise AlgorithmiaApiKeyInvalid, "The API key you sent is invalid! Please set `Algorithmia::Client.api_key` with the key provided with your account."
      when 'Failed to parse input, input did not parse as valid json'
        raise AlgorithmiaJsonParseFailure, "Unable to parse the input. Please make sure it matches the expected input of the algorithm and can be parsed into JSON."
      else
        if @error[:stacktrace].nil?
          raise UnknownError, "Got an unknown error: #{@error[:message]}"
        else
          raise UnknownError, "Got an unknown error: #{@error[:message]} with stacktrace: #{@error[:stacktrace]}"
        end
      end
    end

    private

    def symbolize_keys(hash)
      hash.inject({}){|result, (key, value)|
        new_key = case key
                  when String then key.to_sym
                  else key
                  end
        new_value = case value
                    when Hash then symbolize_keys(value)
                    else value
                    end
        result[new_key] = new_value
        result
      }
    end
  end

  class AlgorithmiaApiKeyEmpty < Exception; end
  class AlgorithmiaApiKeyInvalid < Exception; end
  class AlgorithmiaUnauthorized < Exception; end
  class AlgorithmiaJsonParseFailure < Exception; end
  class UnknownError < Exception; end
end