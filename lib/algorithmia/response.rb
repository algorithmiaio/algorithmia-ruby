module Algorithmia
  class Response
    def initialize(result)
      @json = symbolize_keys(result)
    end

    def response
      @json
    end
    
    def result
      @json[:result]
    end

    def duration
      @json[:metadata][:duration]
    end
    def metadata
      @json[:metadata]
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