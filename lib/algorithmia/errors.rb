module Algorithmia
  module Errors
    class Error < StandardError
      attr_reader :response

      def initialize(message, response)
        super(message)
        @response = response
      end
    end

    class ApiKeyEmptyError < Error; end
    class ApiKeyInvalidError < Error; end
    class InternalServerError < Error; end
    class JsonParseError < Error; end
    class NotFoundError < Error; end
    class UnauthorizedError < Error; end
    class UnknownError < Error; end
  end
end
