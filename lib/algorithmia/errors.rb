module Algorithmia

  module Errors
    def self.parse_error(error)
      case error["message"]
      when 'authorization required'
        AlgorithmiaApiKeyInvalid.new("The API key you sent is invalid! Please set `Algorithmia::Client.api_key` with the key provided with your account.")
      when 'Failed to parse input, input did not parse as valid json'
        AlgorithmiaJsonParseFailure.new("Unable to parse the input. Please make sure it matches the expected input of the algorithm and can be parsed into JSON.")
      else

        if error["stacktrace"].nil?
          UnknownError.new("Got an unknown error: #{error["message"]}")
        else
          UnknownError.new("Got an unknown error: #{error["message"]} with stacktrace: #{error["stacktrace"]}")
        end
      end
    end

    class AlgorithmiaApiKeyEmpty < StandardError; end
    class AlgorithmiaApiKeyInvalid < StandardError; end
    class AlgorithmiaUnauthorized < StandardError; end
    class AlgorithmiaNotFound < StandardError; end
    class AlgorithmiaJsonParseFailure < StandardError; end
    class UnknownError < StandardError; end
  end
end
