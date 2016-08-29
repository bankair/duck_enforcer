# encoding: utf-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'duck_enforcer/version'

Gem::Specification.new do |s|
  s.name = 'duck_enforcer'
  s.version = DuckEnforcer::Version::STRING
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.0.0'
  s.authors = ['Alexandre Ignjatovic']
  s.description = <<-EOF
    A duck typing enforcer.
  EOF

  s.email = 'alexandre.ignjatovic@gmail.com'
  s.files = `git ls-files`.split($RS).reject do |file|
    file =~ %r{^(?:
    spec/.*
    |Gemfile
    |Rakefile
    |\.rspec
    |\.gitignore
    |\.rubocop.yml
    |\.rubocop_todo.yml
    |.*\.eps
    )$}x
  end
  s.test_files = []
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.extra_rdoc_files = ['LICENSE.txt', 'README.md']
  s.homepage = 'http://github.com/bankair/duck_enforcer'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.23'

  s.summary = 'A ruby microframework to enforce duck typing.'

  s.add_development_dependency('rspec', '~> 3.4')
end
