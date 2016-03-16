module Algorithmia
  class Response
    def initialize(result)
      @raw_response = result
      @json = symbolize_keys(result)
    end

    def raw
      # full response from algorithm call
      @raw_response
    end

    def result
      # successful result from the algorithm
      @json[:result]
    end

    def metadata
      @json[:metadata]
    end

    def duration
      @json[:metadata][:duration]
    end

    def content_type
      @json[:metadata][:content_type]
    end

    def stdout
      @json[:metadata][:stdout]
    end

    def alerts
      @json[:metadata][:alerts]
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