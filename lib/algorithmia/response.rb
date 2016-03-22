module Algorithmia
  class Response
    def initialize(result)
      @json = result
    end

    def result
      # successful result hash from the algorithm
      @json["result"]
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
