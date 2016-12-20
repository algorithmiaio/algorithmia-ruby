require "base64"

module Algorithmia
  class Response
    attr_reader :response

    def initialize(response, output_type)
      @response = response
      @output_type = output_type
    end

    def result
      if @output_type == 'raw'
        @response
      elsif content_type == 'binary'
        Base64.decode64(@response["result"])
      else
        @response["result"]
      end
    end

    def metadata
      if @output_type == 'raw'
        nil
      else
        @response["metadata"]
      end
    end

    def duration
      if @output_type == 'raw'
        nil
      else
        metadata["duration"]
      end
    end

    def content_type
      if @output_type == 'raw'
        nil
      else
        metadata["content_type"]
      end
    end

    def stdout
      if @output_type == 'raw'
        nil
      else
        metadata["stdout"]
      end
    end

    def alerts
      if @output_type == 'raw'
        nil
      else
        metadata["alerts"]
      end
    end
  end
end
