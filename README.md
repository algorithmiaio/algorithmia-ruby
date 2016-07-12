# The Algorithmia Ruby Client

The Algorithmia Ruby client is a wrapper for making calls to the Algorithmia API and Data API.

With Algorithmia, you can leverage algorithms written in any language by including them in your Ruby project with a simple API call! Browse the collection of algorithms available on [Algorithmia.com](http://algorithmia.com).

## Getting started

The Algorithmia ruby client is [available on rubygems](https://rubygems.org/gems/algorithmia).
Simply add `gem 'algorithmia'` to your application's Gemfile and run `bundle install`.

Then create an Algorithmia client and authenticate with your API key:

```ruby
require algorithmia

client = Algorithmia.client('YOUR_API_KEY')
```

You are now ready to call algorithms.

## Calling algorithms

The following examples of calling algorithms are organized by type of input/output which vary between algorithms.

Note: a single algorithm may have different input and output types, or accept multiple types of input,
so consult the algorithm's description for usage examples specific to that algorithm.

### Text input/output

Call an algorithm with text input by simply passing a string into its `pipe` method.
If the algorithm output is text, then the result field of the response will be a string.

```ruby
algo = client.algo('demo/Hello/0.1.1')
puts algo.pipe('HAL 9000').result
# -> Hello HAL 900
```

### JSON input/output

Call an algorithm with JSON input by simply passing in a type that can be serialized to JSON, like an `Array` or `Hash`.
For algorithms that return JSON, the result field of the response will be the appropriate deserialized type.

```ruby
algo = client.algo('WebPredict/ListAnagrams/0.1.0')
result = algo.pipe(["transformer", "terraforms", "retransform"]).result
# -> ["transformer","retransform"]
```

Alternatively, if your input is already serialized to JSON, you may call `pipe_json`:

```ruby
algo = client.algo('WebPredict/ListAnagrams/0.1.0')
result = algo.pipe_json('["transformer", "terraforms", "retransform"]').result
# -> ["transformer","retransform"]
```

### Binary input/output

Call an algorithm with Binary input by passing an `ASCII-8BIT`-encoded string into the `pipe` method.
Similarly, if the algorithm response is binary data, then the result field of the response will be an `ASCII-8BIT` string.
In practice, this involves working with methods like `IO.binread` and `IO.binwrite`.

```ruby
input = File.binread("/path/to/bender.png")
result = client.algo("opencv/SmartThumbnail/0.1").pipe(input).result
# -> [ASCII-8BIT string of binary data]
```

### Error handling

API errors and Algorithm exceptions will be raised when calling `pipe`:

```ruby
client.algo('util/whoopsWrongAlgo').pipe('Hello, world!')
# -> Algorithmia::Errors::NotFoundError: algorithm algo://util/whoopsWrongAlgo not found
```

### Request options

The client exposes options that can configure algorithm requests.
This includes support for changing the timeout or indicating that the API should include stdout in the response.

```ruby
algo = client.algo('demo/Hello/0.1.1').set_timeout(10).enable_stdout
response = algo.pipe('HAL 9000')
stdout = response.stdout
```

Note: `enable_stdout` is ignored if you do not have access to the algorithm source.


## Working with data

The Algorithmia Java client also provides a way to manage both Algorithmia hosted data
and data from Dropbox or S3 accounts that you've connected to you Algorithmia account.

This client provides a `DataFile` type (generally created by `client.file(uri)`)
and a `DataDir` type (generally created by `client.dir(uri)`) that provide methods for managing your data.

### Create directories

Create directories by instantiating a `DataDirectory` object and calling `create`:

```ruby
client.dir("data://.my/robots").create
client.dir("dropbox://robots").create
```

### Upload files to a directory

Upload files by calling `put` on a `DataFile` object, or by calling `putFile` on a `DataDirectory` object.

```ruby
robots = client.dir("data://.my/robots")

# Upload local file
robots.put_file("/path/to/Optimus_Prime.png")
# Write a text file
robots.file("Optimus_Prime.txt").put("Leader of the Autobots")
# Write a binary file
robots.file("Optimus_Prime.key").put([71, 101, 101, 107].pack('C*'))
```

### Download contents of file

Download files by calling `get` or `get_file` on a `DataFile` object:

```ruby
# Download file and get the file handle
t800File = client.file("data://.my/robots/T-800.png").get_file

# Get file's contents as a string
t800Text = client.file("data://.my/robots/T-800.txt").get

# Get file's contents as JSON
t800JsonString = client.file("data://.my/robots/T-800.txt").get
t800Json =  JSON.parse(t800JsonString)

# Get file's contents as a byte array
t800Bytes = client.file("data://.my/robots/T-800.png").get
```

### Delete files and directories

Delete files and directories by calling delete on their respective `DataFile` or `DataDirectory` object.
DataDirectories take an optional `force` parameter that indicates whether the directory should be deleted
if it contains files or other directories.

```ruby
client.file("data://.my/robots/C-3PO.txt").delete

client.dir("data://.my/robots").delete(false)
```

### List directory contents

Iterate over the contents of a directory using the iterated returned
by calling `each`, `each_directory`, or `each_file` on a `DataDirectory` object.
If no block is given to the method, an enumerator will be returned.

```ruby
# List top level directories
client.dir("data://.my").each_dir do |dir|
    puts "Directory " + dir.data_uri
end

# List files in the 'robots' directory
client.dir("data://.my/robots").each_file do |file|
    puts "File " + file.data_uri
end

# Iterate all directory contents
client.dir("dropbox://").each do |item|
    puts file.data_uri
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/algorithmiaio/algorithmia-ruby). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

