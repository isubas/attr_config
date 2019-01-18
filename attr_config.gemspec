lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attr_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'attr_config'
  spec.version       = AttrConfig::VERSION
  spec.authors       = ['isubas']
  spec.email         = ['irfan.isubas@gmail.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'http://github.com/isubas/attr_config'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*', 'CHANGELOG.md', 'LICENSE.txt', 'README.md']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'pry', '~> 0.12.2'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'reek', '~> 5.3'
  spec.add_development_dependency 'rubocop', '~> 0.61.1'
end
