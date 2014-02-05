# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'requirement_authorization/version'

Gem::Specification.new do |spec|
  spec.name          = "requirement_authorization"
  spec.version       = RequirementAuthorization::VERSION
  spec.authors       = ["Brad Gessler"]
  spec.email         = ["brad@polleverywhere.com"]
  spec.summary       = %q{Quickly create before_filters in Rails that protect resources.}
  spec.homepage      = "https://github.com/bradgessler/requirement_authorization"
  spec.license       = "MIT"
  spec.date           = "2009-10-20"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
