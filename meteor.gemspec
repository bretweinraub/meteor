# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'meteor/version'

Gem::Specification.new do |spec|
  spec.name          = "meteor"
  spec.version       = Meteor::VERSION
  spec.authors       = ["Bret Weinraub"]
  spec.email         = ["support@aura-software.com"]
  spec.description   = %q{Meteor is a stateless widget framework for Ruby on Rails}
  spec.summary       = %q{Meteor is a stateless widget framework for Ruby on Rails}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
