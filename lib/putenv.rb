require 'thor'
require 'putenv/messages'
require 'putenv/config'
require 'putenv/plugin'
require 'putenv/provider'
require 'putenv/platform'
require 'putenv/build'
require 'putenv/provision'

# Refer to README.md for use instructions
module Putenv
  # Start of main CLI
  class CLI < Thor
    package_name 'putenv'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    def version
      puts VERSION
    end

    desc 'new', DESC_NEW
    method_options %w( provider -p ) => :string, :required => false
    def new
      Putenv::Provider.new(options[:provider]).new_definition
    end

    # rubocop:disable LineLength
    desc 'health [ENVIRONMENT]', DESC_HEALTH
    method_options %w( provider -p ) => :string
    def health(env = '')
      provider = options[:provider] ? Putenv::Provider.new(options[:provider]) : nil
      # puts HEALTHY if Putenv::Platform.new(Putenv::Provider.new(options[:provider])).healthy?(env)
      puts HEALTHY if Putenv::Platform.new(provider).healthy?(env)
    end
    # rubocop:enable LineLength

    # subcommand in Thor called as registered class
    register(Putenv::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    register(Putenv::Build, 'build', 'build TARGET', DESC_BUILD)
  end
end
