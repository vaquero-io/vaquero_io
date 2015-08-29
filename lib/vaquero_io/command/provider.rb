# Copyright information in version.rb
#
require 'vaquero_io/command'

module VaqueroIo
  # included in Command module
  module Command
    # command processor
    class Provider < VaqueroIo::Command::Base
      # invoke the command
      def call
        case
        when options[:list]
          Gem::Specification.all_names.grep(PROVIDERGEMPATTERN).each { |g| puts g }
        when options[:create]
          puts 'TODO: create new providerfile template for developing new plugin gem'
        when options[:discover]
          puts available_providers
        else
          default_provider
        end
      end

      private

      def available_providers
        requirements = Gem::Requirement.default
        dependencies = Gem::Deprecate.skip_during do
          Gem::Dependency.new(PROVIDERGEMPATTERN, requirements)
        end
        fetch_gems(Gem::SpecFetcher.fetcher, dependencies)
      end

      def fetch_gems(search_results, dependencies)
        specs = search_results.spec_for_dependency(dependencies, false)
        specs.first.map { |t| [t.first.name] }
      end

      def default_provider
        if ENV['VAQUEROIO_DEFAULT_PROVIDER'].empty?
          puts 'No default provider specified in .env file'
        else
          puts "default provider is #{ENV['VAQUEROIO_DEFAULT_PROVIDER']}"
        end
      end
    end
  end
end
