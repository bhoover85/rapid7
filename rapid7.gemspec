# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapid7/version'

Gem::Specification.new do |spec|
  spec.name          = "rapid7"
  spec.version       = Rapid7::VERSION
  spec.authors       = ["Brad Hoover"]
  spec.email         = ["hoov1185@gmail.com"]
  spec.summary       = %q{Rapid7 assignment}
  spec.description   = %q{Rapid7 assignment}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
