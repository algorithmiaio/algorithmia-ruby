# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'algorithmia/version'

Gem::Specification.new do |spec|
  spec.name          = "algorithmia"
  spec.version       = Algorithmia::VERSION
  spec.authors       = ["Algorithmia"]
  spec.email         = ["developer@algorithmia.com"]
  spec.licenses      = ["MIT"]
  spec.summary       = %q{A Ruby client for making API calls to Algorithmia}
  spec.description   = %q{This gem provides a friendly client interface to the Algorithmia API, allowing you to call any of the algorithms on the Algorithmia Marketplace.}
  spec.homepage      = "https://algorithmia.com/"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 11.1"
  spec.add_development_dependency "rspec", "~> 3.4"

  spec.add_dependency "json", "~> 1.8"
  spec.add_dependency "httparty", "~> 0.13"

end
