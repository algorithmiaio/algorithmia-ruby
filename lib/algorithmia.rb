require_relative 'algorithmia/algorithm'
require_relative 'algorithmia/client'
require_relative 'algorithmia/unauthenticated_client'
require_relative 'algorithmia/errors'
require_relative 'algorithmia/http'
require_relative 'algorithmia/response'
require_relative 'algorithmia/version'
require_relative 'algorithmia/data_object'
require_relative 'algorithmia/data_file'
require_relative 'algorithmia/data_directory'

module Algorithmia

  class << self
    def algo(endpoint)
      Algorithmia::UnauthenticatedClient.new.algo(endpoint)
    end

    def file(data_uri)
      Algorithmia::UnauthenticatedClient.new.file(data_uri)
    end

    def dir(data_uri)
      Algorithmia::UnauthenticatedClient.new.dir(data_uri)
    end

    def client(api_key)
      Algorithmia::Client.new(api_key)
    end
  end
end
