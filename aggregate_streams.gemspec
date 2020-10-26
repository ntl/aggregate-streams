# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'aggregate_streams'
  s.summary = "Combine messages from multiple Eventide streams into an aggregate stream"
  s.version = '0.0.0.0'
  s.description = ' '

  s.authors = ['Nathan Ladd']
  s.email = 'nathanladd@gmail.com'
  s.homepage = 'https://github.com/ntl/aggregate-streams'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.7'

  s.add_dependency 'evt-consumer-postgres'

  s.add_development_dependency 'test_bench'
  s.add_development_dependency 'evt-component_host'
end
