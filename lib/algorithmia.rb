require 'httparty'

require 'algorithmia/version'
require 'algorithmia/authentication'
require 'algorithmia/errors'
require 'algorithmia/http'

module Algorithmia

  class Client
    include HTTParty
    base_uri 'https://api.algorithmia.com/v1'
    format :json

    def self.call(endpoint, input)
      post_http("/#{endpoint}", input.to_json)
    end
  end
end