lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vaquero_io/version'
# require "English"

Gem::Specification.new do |gem|
  gem.name          = VaqueroIo::APP_NAME
  gem.version       = VaqueroIo::VERSION
  gem.authors       = %w('Nic Cheneweth','Gregory Ruiz-ade')
  gem.email         = %w('Nic.Cheneweth@thoughtworks.com', \
                         'gregory.ruiz-ade@activenetwork.com')
  gem.summary       = 'Automated provisioning of application environments'
  gem.description   = 'Command line tool to automate the provision and ' \
                      'bootstrap of virtual machine application environments'
  gem.license       = 'Apache 2.0'
  gem.homepage      = 'http://vaquero.io/'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = %w(vaquero_io)
  # gem.test_files    = gem.files.grep(%r{/^\/(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.required_ruby_version = '>= 2.0.0'

  # gem.add_dependency "safe_yaml",           "~> 1.0"
  gem.add_dependency 'thor',                  '~> 0.19'
  gem.add_dependency 'remote_syslog_logger',  '~> 1.0'    # support for papertrail.com
  gem.add_dependency 'logglier',              '~> 0.2'    # support for loggly.com
  gem.add_dependency 'dotenv',                '~> 2.0'

  gem.add_development_dependency 'bundler',         '~> 1.8'
  gem.add_development_dependency 'rake',            '~> 10.0'
  gem.add_development_dependency 'rubocop',         '~> 0.30'
  gem.add_development_dependency 'aruba',           '~> 0.6'
  gem.add_development_dependency 'cucumber',        '~> 2.0'
  gem.add_development_dependency 'rspec',           '~> 3.0'
  gem.add_development_dependency 'coveralls',       '~> 0.8'
  # gem.add_development_dependency "simplecov",     "~> 0.7"
  # gem.add_development_dependency "yard",          "~> 0.8"
  gem.add_development_dependency 'guard',           '~> 2.0'
  gem.add_development_dependency 'guard-rubocop',   '~> 1.2'
  gem.add_development_dependency 'guard-rspec',     '~> 4.5'
  gem.add_development_dependency 'guard-cucumber',  '~> 1.6.0'
  # gem.add_development_dependency 'guard-yard',      '>= 2.1.4'

  # legacy
  gem.add_dependency 'git'
  #


end

# style and complexity libraries are tightly version pinned as newer releases
# may introduce new and undesireable style choices which would be immediately
# enforced in CI
# gem.add_development_dependency "finstyle"

# gem.add_dependency "mixlib-shellout",     ">= 1.2", "< 3.0"
# gem.add_dependency "net-scp"
# gem.add_dependency "net-ssh"

# gem.add_development_dependency "pry"
# gem.add_development_dependency "winrm-transport"
# gem.add_development_dependency "fakefs"
# gem.add_development_dependency "minitest"
# gem.add_development_dependency "mocha"
# gem.add_development_dependency "countloc"
# gem.add_development_dependency "maruku"