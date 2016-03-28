# The Algorithmia Ruby Client

The Algorithmia Ruby client is a wrapper for making calls to the Algorithmia API and Data API.

With Algorithmia, you can leverage algorithms written in any language by including them in your Ruby project with a simple API call! Browse the collection of algorithms available on [Algorithmia.com](http://algorithmia.com).

## Installation

#### Local Builds:

Because this gem is yet to be released on ruby gems, follow these instructions to build and use it locally:

```bash
gem build algorithmia.gemspec && gem install algorithmia-0.1.0.gem
```

#### Regular installation:
Add this line to your application's Gemfile:

```ruby
gem 'algorithmia'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install algorithmia
```

## Basic Usage

To call to the API, the gem uses a client model. Create and configure a client object with your API key to start making requests.

```ruby
require algorithmia

# Create a new client instance & set your API key
client = Algorithmia.client('YOUR_API_KEY')

algorithm        = 'demo/Hello/0.1.1'
algorithm_result = client.algo(algorithm).pipe("HAL 9000").result
puts algorithm_result
# => Hello HAL 9000
```

### Algorithm Objects

When you call `.algo` on your client, it will return a new instance of `Algorithmia::Algorithm`. On this object, you have the the following methods:
- `pipe`: the default method to calling an algorithm (recommended)
- `pipeJson`
- `set_options`: set query parameters on your request

```ruby
algorithm = client.algo('demo/Hello/0.1.1')
# => #<Algorithmia::Algorithm:0x007f80ea092fc8 @client=Algorithmia::Client, @endpoint="demo/Hello/0.1.1", @query_options={:timeout=>300, :stdout=>false, :output=>"default"}>

# Pass in a hash of options to override the default query parameters
algorithm.set_options({'timeout': 500})
# => {:timeout=>500, :stdout=>false, :output=>"default"}

# Use these helper methods to enable stdout or change the timeout value
algorithm.set_timeout(500)
# => 500
algorithm.enable_stdout
# => true
algorithm
# => #<Algorithmia::Algorithm:0x007fa008b02de0 @client=Algorithmia::Client, @endpoint="demo/hello", @query_options={:timeout=>500, :stdout=>true, :output=>"default"}>

# Pass the input to the algorithm
result = algorithm.pipe('HAL 9000')
# => Hello HAL 9000
```

### Algorithm Responses

When a successful response from the algorithm is returned, a new Algorithmia::Response object is created. 

``` ruby
# Call an algorithm
algorithm_response = client.algo(algorithm).pipe("HAL 9000").result
puts algorithm_response
# => #<Algorithmia::Response:0x007f9fc2845850 @json={:result=>0.14970585904042558, :metadata=>{:content_type=>"json", :duration=>0.0006857780000000001}}>

# Get the raw json returned from the API
puts algorithm_response.raw_json
# => {:result=>0.14970585904042558, :metadata=>{:content_type=>"json", :duration=>0.0006857780000000001}}

# Use any one of the following helper methods to understand the response
puts algorithm_response.result
# => 0.14970585904042558
puts algorithm_response.metadata
# => {:content_type=>"json", :duration=>0.0006857780000000001}
puts algorithm_response.duration
# => 0.0006857780000000001
puts algorithm_response.content_type
# => "json"
puts algorithm_response.stdout
# => nil
puts algorithm_response.alerts
# => nil
```

### The Data API

The client also allows you to work with the Algorithmia Data API. You can manage your files and directories using DataObjects. There are two types of DataObjects: `DataFile` and `DataDirectory`.

#### DataFiles

```ruby
file = @client.file('data://test_user/test/sample_file.txt')
 => #<Algorithmia::DataFile:0x007ffbaa8747d8 @client=#<Algorithmia::Client:0x007ffbab0fc798 @api_key="YOUR_API_KEY">, @data_uri="data://test_user/test/sample_file.txt", @url="/data/test_user/test/sample_file.txt"> 

file.put_file('/path/to/local/file/sample_file.txt')
# => true

file.exists?
# => true

# Write a string to the file. This will overwrite any existing content!
file.put("This is the contents of the file.")
# => true

# Get the file and write to a local file
file.get_file
# => #<File:/var/folders/yl/vv6ws5196cvb61xzwrg8l3vm0000gp/T/test.txt20160328-94761-i8cqxg> 

file.get_string
# => "This is the contents of the file."

file.get_bytes 
#=> [34, 84, 104, 105, 115, 32, 105, 115, 32, 116, 104, 101, 32, 99, 111, 110, 116, 101, 110, 116, 115, 32, 111, 102, 32, 116, 104, 101, 32, 102, 105, 108, 101, 46, 34] 

file.delete
# => true
```

#### DataDirectories

```ruby
# Create a DataDirectory object
dir = @client.dir('data://test_user/test')
# => #<Algorithmia::DataDirectory:0x007ffbab0fc748 @client=#<Algorithmia::Client:0x007ffbab0fc798 @api_key="YOUR_API_KEY">, @data_uri="data://test_user/test", @url="/data/test_user/test"> 

dir.exists?
# => true

# Get a new DataDirectory object for the parent directory
dir.parent
# => #<Algorithmia::DataDirectory:0x007ffba924e148 @client=#<Algorithmia::Client:0x007ffbab0fc798 @api_key="YOUR_API_KEY">, @data_uri="data://test_user", @url="/data/test_user"> 

# Delete the directory
dir.delete
# => true

# Create a new directory
dir = @client.dir('data://test_user/test_two')
dir.create
# => true
```

##### Working with directories:

You can iterate over all contents in a directory, only the sub-directories, or the files within the directory by using of the the `each` methods provided. If no block is given to the method, an enumerator will be returned:

```ruby
# Return an enumerator for all directory contents, each sub-directory, or each file in the directory
dir.each
dir.each_directory
dir.each_file
#  => #<Enumerator: #<Algorithmia::DataDirectory:0x007ffba89bbcd8 @client=#<Algorithmia::Client:0x007ffbab0fc798 @api_key="YOUR_API_KEY">, @data_uri="data://test_user/test_two", @url="/data/test_user/test_two">:each> 

# Iterate all directory contents, each sub-directory, or each file in the directory
dir.each { |item| block }
dir.each_directory { |dir| block }
dir.each_file { |file| block }
```


## Stuck? Need help?

Check out our guides, tutorials, and how-tos in the [Algorithmia Developer Center](http://developers.algorithmia.com) as well as finding more specifics in our [API documentation](http://docs.algorithmia.com).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/algorithmiaio/algorithmia-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Not Yet Implemented:
- Tests! :scream:

