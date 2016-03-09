require 'algorithmia/version'
require 'httparty'

module Algorithmia

  class Client
    include HTTParty
    base_uri 'https://api.algorithmia.com/v1'
  end
end
