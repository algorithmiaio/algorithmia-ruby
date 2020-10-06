require 'cgi'

module Algorithmia
  class DataDirectory < DataObject

    def exists?
      Algorithmia::Requester.new(@client).get(@url)
      true
    rescue Errors::NotFoundError
      false
    end

    def create
      parent, name = File.split(@url)
      Algorithmia::Requester.new(@client).post(parent, { name: name })
      true
    end

    def delete(force = false)
      query = {}
      query[:force] = true if force
      Algorithmia::Requester.new(@client).delete(@url, query: query)
      true
    end

    def each(&block)
      return enum_for(:each) unless block_given?

      list(block) do |dir|
        extract_files(dir) + extract_folders(dir)
      end
    end

    def each_file(&block)
      return enum_for(:each_file) unless block_given?

      list(block) do |dir|
        extract_files(dir)
      end
    end

    def each_dir(&block)
      return enum_for(:each_dir) unless block_given?

      list(block) do |dir|
        extract_folders(dir)
      end
    end

    def file(file_name)
      @client.file(File.join(@data_uri, CGI.escape(file_name)))
    end

    def put_file(file_path)
      file(File.basename(file_path)).put_file(file_path)
    end

    private

    def extract_files(dir)
      files = dir.parsed_response['files'] || []
      files.map do |f|
        file(f['filename'])
      end
    end

    def extract_folders(dir)
      folders = dir.parsed_response['folders'] || []
      folders.map do |f|
        @client.dir(File.join(@data_uri, CGI.escape(f['name'])))
      end
    end

    def list(each_proc)
      marker = nil

      loop do
        query = {}
        query[:marker] = marker if marker

        dir = Algorithmia::Requester.new(@client).get(@url, query: query)

        items = yield dir
        items.each(&each_proc)

        marker = dir.parsed_response['marker']
        break unless marker && !marker.empty?
      end
    end
  end
end
