lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require 'tusks/version'

Gem::Specification.new do |s|
  s.name = 'tusks'
  s.version = Tusks::VERSION
  s.license = 'MIT'
  s.platform = Gem::Platform::RUBY
  s.author = 'Craig McCown'
  s.email = 'craigrmccown@gmail.com'
  s.homepage = 'https://github.com/craigrmccown/tusks'
  s.summary = 'Easily call PostgreSQL functions from Ruby.'
  s.description = 'Tusks is built for Ruby application developers who want to access their Postgres database exclusively using functions. It abstracts away ugly serialization functionality, enables easy transaction management, and provides a declarative way to define a clean interface to your Postgres functions.'
  s.post_install_message = 'Thanks for using Tusks! Log and track issues at: https://github.com/craigrmccown/tusks/issues'

  s.required_ruby_version = '2.1.0'
  s.required_rubygems_version = '2.2.2'

  s.files = `git ls-files -z`.split("\x0")
  s.test_files = Dir.glob('spec/**/*')
  s.require_paths = ['lib']
end
