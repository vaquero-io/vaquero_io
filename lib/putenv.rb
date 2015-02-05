require 'thor'
require 'putenv/messages'
require 'putenv/config'
require 'putenv/plugin'
require 'putenv/provider'
require 'putenv/platform'

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
    method_options %w( provider -p ) => :string
    def new
      Putenv::Provider.new(options[:provider]).new_definition
    end

    desc 'health [ENVIRONMENT]', DESC_HEALTH
    method_options %w( provider -p ) => :string
    def health(env='')
      puts HEALTHY if Putenv::Platform.new(Putenv::Provider.new(options[:provider])).healthy?(env)
    end

    # subcommand in Thor called as registered class
    register(Putenv::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
  end
end
