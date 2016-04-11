require "base64"

module Algorithmia
  class Response
    attr_reader :json

    def initialize(result)
      @json = result
    end

    def result
      if content_type == 'binary'
        Base64.decode64(@json["result"])
      else
        @json["result"]
      end
    end

    def metadata
      @json["metadata"]
    end

    def duration
      metadata["duration"]
    end

    def content_type
      metadata["content_type"]
    end

    def stdout
      metadata["stdout"]
    end

    def alerts
      metadata["alerts"]
    end
  end
end
