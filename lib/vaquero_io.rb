require 'thor'
require 'vaquero_io/version'
require 'vaquero_io/messages'
require 'vaquero_io/config'
require 'vaquero_io/plugin'
require 'vaquero_io/provider'
require 'vaquero_io/platform'
require 'vaquero_io/build'
require 'vaquero_io/provision'

# Refer to README.md for use instructions
module VaqueroIo
  # Start of main CLI
  class CLI < Thor
    package_name 'vaquero_io'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    def version
      puts VERSION
    end

    desc 'new', DESC_NEW
    method_options %w( provider -p ) => :string, :required => true
    def new
      VaqueroIo::Provider.new(options[:provider]).new_definition
    end

    # rubocop:disable LineLength
    desc 'health [ENVIRONMENT]', DESC_HEALTH
    method_options %w( provider -p ) => :string
    def health(env = '')
      provider = options[:provider] ? VaqueroIo::Provider.new(options[:provider]) : nil
      # puts HEALTHY if VaqueroIo::Platform.new(VaqueroIo::Provider.new(options[:provider])).healthy?(env)
      puts HEALTHY if VaqueroIo::Platform.new(provider).healthy?(env)
    end
    # rubocop:enable LineLength

    # subcommand in Thor called as registered class
    register(VaqueroIo::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    register(VaqueroIo::Build, 'build', 'build TARGET', DESC_BUILD)
  end
end
