# The Algorithmia Ruby Client

The Algorithmia Ruby client is a wrapper for making calls to the Algorithmia API and Data API.

With Algorithmia, you can leverage algorithms written in any language by including them in your Ruby project with a simple API call! Browse the collection of algorithms available on [Algorithmia.com](http://algorithmia.com).

## Installation

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

# Create a new client instance
client = Algorithmia::Client
# Authenticate with your API key
client.api_key = 'YOUR_API_KEY'

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

## Stuck? Need help?

Check out our guides, tutorials, and how-tos in the [Algorithmia Developer Center](http://developers.algorithmia.com) as well as finding more specifics in our [API documentation](http://docs.algorithmia.com).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/algorithmiaio/algorithmia-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Not Yet Implemented:
- Interacting with the Algorithmia Data API
    + DataFile Object
    + DataDirectory Object
- Non-authenticated methods on client
- Passing in query parameters such as setting timeout values
- Tests! :scream:

