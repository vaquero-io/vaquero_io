require 'thor'
require 'vaquero/messages'
require 'vaquero/config'
require 'vaquero/plugin'
require 'vaquero/provider'
require 'vaquero/platform'
require 'vaquero/build'
require 'vaquero/provision'

# Refer to README.md for use instructions
module Vaquero
  # Start of main CLI
  class CLI < Thor
    package_name 'vaquero'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    def version
      puts VERSION
    end

    desc 'new', DESC_NEW
    method_options %w( provider -p ) => :string, :required => false
    def new
      Vaquero::Provider.new(options[:provider]).new_definition
    end

    # rubocop:disable LineLength
    desc 'health [ENVIRONMENT]', DESC_HEALTH
    method_options %w( provider -p ) => :string
    def health(env = '')
      provider = options[:provider] ? Vaquero::Provider.new(options[:provider]) : nil
      # puts HEALTHY if Vaquero::Platform.new(Vaquero::Provider.new(options[:provider])).healthy?(env)
      puts HEALTHY if Vaquero::Platform.new(provider).healthy?(env)
    end
    # rubocop:enable LineLength

    # subcommand in Thor called as registered class
    register(Vaquero::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    register(Vaquero::Build, 'build', 'build TARGET', DESC_BUILD)
  end
end
