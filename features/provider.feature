Feature: Provider plugin gems

  As an Infracoder developing the vaquero command line tool
  I want to test the accuracy of the Provider gem interactions for the Provider command
  In order to maintain the users ability to use and create provider plugin gems for custom infrastructure targets

  Scenario: Request help with Provider commands

    When I get general help for "vaquero_io help provider"
    Then the exit status should be 0
    And the following commands should be documented:
      |list|
      |create|
      |discover|

  Scenario: List installed Providers

    # vaquero_io-provider-gem-test is a development dependency
    When I run `vaquero_io provider --list`
    Then the output should contain "vaquero_io"

  Scenario: List available Providers

    # searches RubyGems.org for related gmes
    When I run `vaquero_io provider --discover`
    Then the output should contain "vaquero_io"

  Scenario: New Providerfile template

#    When I run `vaquero_io provider --template`
#    Then the exit status should be 0
#    And the output should contain "create  Providerfile.yml"
#    And the following files should exist:
#      |Providerfile.yml|
#    And the file "Providerfile.yml" should contain:
#    """
#    provider:
#      # define the plugin name that can be used to select this provider from the command line or environmental variable
#      name:
#      version: 0.0.0
#    """
#

#  -*- encoding: utf-8 -*-
## stub: aruba 0.8.1 ruby lib
#
#  Gem::Specification.new do |s|
#  s.name = "aruba"
#  s.version = "0.8.1"
#
#  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
#  s.require_paths = ["lib"]
#  s.authors = ["Aslak Helles\u{f8}y", "David Chelimsky", "Mike Sassak", "Matt Wynne", "Jarl Friis", "Dennis G\u{fc}nnewig"]
#  s.date = "2015-07-15"
#  s.description = "Extension for popular TDD and BDD frameworks like \"Cucumber\" and \"RSpec\" to make testing commandline applications meaningful, easy and fun."
#  s.email = "cukes@googlegroups.com"
#  s.homepage = "http://github.com/cucumber/aruba"
#  s.licenses = ["MIT"]
#  s.post_install_message = "Use on ruby 1.8.7\n* Make sure you add something like that to your `Gemfile`. Otherwise you will\n  get cucumber > 2 and this will fail on ruby 1.8.7\n\n  gem 'cucumber', ~> '1.3.20'\n\nWith aruba >= 1.0 there will be breaking changes. Make sure to read https://github.com/cucumber/aruba/blob/master/History.md for 1.0.0\n"
#  s.rdoc_options = ["--charset=UTF-8"]
#  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
#  s.rubygems_version = "2.4.5"
#  s.summary = "aruba-0.8.1"
#
#  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version
#
#  if s.respond_to? :specification_version then
#  s.specification_version = 4
#
#  if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
#  s.add_runtime_dependency(%q<cucumber>, [">= 1.3.19"])
#  s.add_runtime_dependency(%q<childprocess>, ["~> 0.5.6"])
#  s.add_runtime_dependency(%q<rspec-expectations>, [">= 2.99"])
#  s.add_runtime_dependency(%q<contracts>, ["~> 0.9"])
#  s.add_development_dependency(%q<bundler>, ["~> 1.10.2"])
#  else
#  s.add_dependency(%q<cucumber>, [">= 1.3.19"])
#  s.add_dependency(%q<childprocess>, ["~> 0.5.6"])
#  s.add_dependency(%q<rspec-expectations>, [">= 2.99"])
#  s.add_dependency(%q<contracts>, ["~> 0.9"])
#  s.add_dependency(%q<bundler>, ["~> 1.10.2"])
#  end
#  else
#  s.add_dependency(%q<cucumber>, [">= 1.3.19"])
#  s.add_dependency(%q<childprocess>, ["~> 0.5.6"])
#  s.add_dependency(%q<rspec-expectations>, [">= 2.99"])
#  s.add_dependency(%q<contracts>, ["~> 0.9"])
#  s.add_dependency(%q<bundler>, ["~> 1.10.2"])
#  end
#  end