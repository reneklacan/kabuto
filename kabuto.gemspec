$:.push File.expand_path("../lib", __FILE__)

require 'kabuto/version'

Gem::Specification.new do |s|
  s.name        = 'kabuto'
  s.version     = Kabuto::VERSION
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = ''
  s.description = ''
  s.authors     = ['Rene Klacan']
  s.email       = 'rene@klacan.sk'
  s.files       = Dir["{lib}/**/*", "LICENSE", "README.md"]
  s.executables = []
  s.homepage    = 'https://github.com/reneklacan/kabuto'
  s.license     = 'Beerware'

  s.required_ruby_version = '>= 1.9'

  s.add_dependency 'nokogiri', '~> 1.6'
  s.add_dependency 'hashie', '~> 3.4'
  s.add_dependency 'json', '~> 1.8'

  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rspec-mocks', '~> 3.4'
  s.add_development_dependency 'pry-byebug', '~> 2.0'
end
