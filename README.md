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

```ruby
require algorithmia

# Create a new client instance
client = Algorithmia.new
# Authenticate with your API key
Algorithmia.api_key = "YOUR_API_KEY"

algorithm        = client.algo('demo/Hello/0.1.1')
algorithm_result = algorithm.pipe("HAL 9000").result
puts algorithm_result
# -> Hello HAL 9000
```

## Stuck? Need help?

Check out our guides, tutorials, and how-tos in the [Algorithmia Developer Center](http://developers.algorithmia.com) as well as finding more specifics in our [API documentation](http://docs.algorithmia.com).

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/algorithmiaio/algorithmia-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

