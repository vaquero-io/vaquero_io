# rubocop:disable all
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require 'vaquero_io/version'

Gem::Specification.new do |spec|
  spec.name          = 'vaquero_io'
  spec.version       = VaqueroIo::VERSION
  spec.authors       = %w('Nic Cheneweth','Gregory Ruiz-ade')
  spec.email         = %w('Nic.Cheneweth@thoughtworks.com','gregory.ruiz-ade@activenetwork.com')
  spec.summary       = 'Automated provisioning of application environments'
  spec.description   = 'Command line tool to automate the provision and bootstrap of virtual machine application environments'
  spec.homepage      = 'http://vaquero.io/'
  spec.license       = 'Apache 2.0'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 1.7'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'rubocop', '>= 0.27.0'
  spec.add_development_dependency 'aruba', '>= 0.6'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'coveralls', '>= 0.7.9'
  spec.add_development_dependency 'guard', '>= 2.10.0'
  spec.add_development_dependency 'guard-rubocop', '>= 1.1.0'
  spec.add_development_dependency 'guard-rspec', '>= 4.5.0'
  spec.add_development_dependency 'guard-cucumber', '>= 1.6.0'
  spec.add_development_dependency 'guard-yard', '>= 2.1.4'
  # growl functionality in Guardfile depends on growlnotify binary
  spec.add_development_dependency 'growl'
  spec.add_development_dependency 'yard', '>= 0.8'
  spec.add_dependency 'thor', '>= 0.18.0'
  spec.add_dependency 'git', '>= 1.2.0'
end
# rubocop:enable all
