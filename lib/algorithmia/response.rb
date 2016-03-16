module Algorithmia
  class Response
    def initialize(result)
      @json = result
      @response = symbolize_keys(result)
    end

    def raw_json
      # full json response from algorithm call
      @json
    end

    def result
      # successful result hash from the algorithm
      @response[:result]
    end

    def metadata
      @response[:metadata]
    end

    def duration
      @response[:metadata][:duration]
    end

    def content_type
      @response[:metadata][:content_type]
    end

    def stdout
      @response[:metadata][:stdout]
    end

    def alerts
      @response[:metadata][:alerts]
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
end