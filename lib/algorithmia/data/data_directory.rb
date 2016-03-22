module Algorithmia
  class DataDirectory < DataObject

    def initialize(client, data_uri)
      super(client, data_uri)
      validate_data_uri
    end

    def validate_data_uri
      # TODO: ensure that the uri passed in starts with data://
      file_path = @data_uri.gsub('data://', '')
      @url = '/data/' + file_path
    end

    def exists?
      Algorithmia::Http.new(@client).get(@url)
    end

    def create
    end

    def delete
      Algorithmia::Http.new(@client).delete(@url, query: { force: :true })
    end

    def getIterator
      # getIterator should iterate over both files and directories
    end

    def getFileIterator
      # getFileIterator should iterate over only files (skipping any directories)
    end

    def getDirIterator
      # getDirIterator should iterate over only directories (skipping any files)
    end

    def file(file_name)
      # TODO: check if filename has leading slash; if not, add it
      @client.file(@data_uri + file_name)
    end

    def put_file(file_path)
      file = File.read(file_path)
      Algorithmia::Http.new(@client).put(@url, file)
    end

    def parent
      @client.dir(Pathname.new(@data_uri).parent.to_s)
    end
  end
end
