$:.push File.expand_path("../lib", __FILE__)

require 'algorithmia/authentication'
require 'algorithmia/errors'
require 'algorithmia/http'
require 'algorithmia/response'
require 'algorithmia/version'

require 'singleton'

module Algorithmia

  class Client
    include Singleton
    attr_writer :api_key

    def self.call(endpoint, input)
      post_http("/#{endpoint}", input.to_json)
    end
  end
end