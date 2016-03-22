$:.push File.expand_path("../lib", __FILE__)

require 'algorithmia/algorithm'
require 'algorithmia/authentication'
require 'algorithmia/errors'
require 'algorithmia/http'
require 'algorithmia/response'
require 'algorithmia/version'
require 'algorithmia/data/data_object'
require 'algorithmia/data/data_file'
require 'algorithmia/data/data_directory'

require 'singleton'

module Algorithmia

  class << self
    def algo(endpoint)
      Algorithmia::Algorithm.new(nil, endpoint)
    end

    def file(data_uri)
      Algorithmia::DataFile.new(nil, data_uri)
    end
  
    def dir(data_uri)
      Algorithmia::DataDirectory.new(nil, data_uri)
    end
  end

  class Client
    include Singleton
    attr_writer :api_key

    def self.algo(endpoint)
      Algorithmia::Algorithm.new(self, endpoint)
    end

    def self.file(endpoint)
      Algorithmia::DataFile.new(self, endpoint)
    end
  end
end