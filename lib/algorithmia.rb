
require 'algorithmia/authentication'
require 'algorithmia/version'
require 'algorithmia/errors'
require 'algorithmia/http'

class Algorithmia

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

  def self.call(endpoint, input)
    post_http("/#{endpoint}", input.to_json)
  end
end
