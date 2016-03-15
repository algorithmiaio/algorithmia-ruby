$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'algorithmia/authentication'
require 'algorithmia/version'
require 'algorithmia/errors'
require 'algorithmia/http'

module Algorithmia

  class Client
    # Initializes a new Algorithmia client object
    #
    # @param options [Hash]
    # @return [Algorithmia]
    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
    end

    def call(endpoint, input)
      Algorithmia::Client.post_http("/#{endpoint}", input.to_json)
    end
  end
end