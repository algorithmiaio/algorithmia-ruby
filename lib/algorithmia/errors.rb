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
      else
        raise UnknownError, "Got an unknown error: #{@error[:message]}"
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
  class UnknownError < Exception; end
end