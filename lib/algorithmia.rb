require 'httparty'

require 'algorithmia/version'
require 'algorithmia/authentication'
require 'algorithmia/errors'

module Algorithmia

  class Client
    include HTTParty
    base_uri 'https://api.algorithmia.com/v1'
  end
end
