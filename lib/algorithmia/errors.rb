module Algorithmia
  module Errors
    class Error < StandardError
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    class AlgorithmError < Error;
      attr_reader :stacktrace
      def initialize(message, response, stacktrace)
        super(message, response)
        @stacktrace = stacktrace
      end
    end

    class ApiKeyEmptyError < Error; end
    class ApiKeyInvalidError < Error; end
    class InternalServerError < Error; end
    class JsonParseError < Error; end
    class NotFoundError < Error; end
    class UnauthorizedError < Error; end
    class ApiError < Error; end
  end
end
