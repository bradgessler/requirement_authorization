require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run specs.'
task :default => :spec

require 'rake'
require 'spec/rake/spectask'

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/*.rb']
  t.fail_on_error = false
end

desc 'Generate documentation for the has_default plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'HasDefault'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "requirement_authorization"
    gemspec.summary = "A lightweight authorization framework that separates the concern of resource access from gathering information necessary to fulfill a request, like singing in with a username and password."
    gemspec.description = ""
    gemspec.email = "brad@conden.se"
    gemspec.homepage = "http://github.com/bradgessler/requirement_authorization"
    gemspec.authors = ["Brad Gessler"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end