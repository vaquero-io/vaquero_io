# Copyright information in version.rb
#
require 'thor'
require 'vaquero_io'

module VaqueroIo
  # CLI Interface
  class CLI < Thor
    map '-v' => :version
    map '--version' => :version

    # Common module to load and invoke a CLI-implementation agnostic command.
    # module PerformCommand
    # Perform a CLI subcommand.
    #
    # @param task [String] action to take, usually corresponding to the
    #   subcommand name
    # @param command [String] command class to create and invoke]
    # @param args [Array] remainder arguments from processed ARGV
    #   (default: `nil`)
    # @param additional_options [Hash] additional configuration needed to
    #   set up the command class (default: `{}`)
    #   def perform(task, command, args = nil, additional_options = {})
    #     require "vaquero_io/command/#{command}"
    #
    #     _command_options = {
    #       action: task,
    #       help: -> { help(task) },
    #       config: @config,
    #       shell: shell
    #     }.merge(additional_options)
    #
    #     str_const = Thor::Util.camel_case(command)
    #     puts "command: #{str_const}, args: #{args}, addl: #{additional_options}"
    #     # klass = ::Poppet::Command.const_get(str_const)
    #     # klass.new(args, options, command_options).call
    #   end
    # end

    # include Logging
    # include PerformCommand

    def initialize(*args)
      super
      $stdout.sync = true
    end

    desc 'version, -v', DESC[:cmd_version]
    def version
      puts "vaquero_io #{VaqueroIo::VERSION}"
    end

    desc 'init', DESC[:cmd_init]
    method_options %w( provider -p ) => :string, :required => true
    def init
      VaqueroIo::Provider.new(options[:provider]).new_definition
    end

    desc 'validate [ENV]|all', DESC[:cmd_validate]
    method_options %w( provider -p ) => :string
    def validate(env = '')
      provider = options[:provider] ? VaqueroIo::Provider.new(options[:provider]) : nil
      puts HEALTHY if VaqueroIo::Platform.new(provider).healthy?(env)
    end

    register(VaqueroIo::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    register(VaqueroIo::Build, 'build', 'build TARGET', DESC_BUILD)
    # desc 'create ENV [-c COMPONENT [-n NODE#..#]]', DESC[:cmd_create]
    # # log_options
    # def create(*args)
    #   # update_config!
    #   perform('create', 'create', args)
    # end
    #
    # desc 'validate [ENV|{all}]', DESC[:cmd_validate]
    # # log_options
    # def validate(*args)
    #   # update_config!
    #   perform('validate', 'validate', args)
    # end
    #
    # desc 'set ENV', DESC[:cmd_set]
    # # log_options
    # def set(*args)
    #   # update_config!
    #   perform('set', 'set', args)
    # end
    #
    # desc 'show [ENV|{all}]', DESC[:cmd_show]
    # # log_options
    # def show(*args)
    #   # update_config!
    #   perform('show', 'show', args)
    # end
    #
    # desc 'destroy ENV [-c COMPONENT [-n NODE#..#]]', DESC[:cmd_destroy]
    # # log_options
    # def destroy(*args)
    #   # update_config!
    #   perform('destroy', 'destroy', args)
    # end
    #
    # desc 'test [ENV|{all}]', DESC[:cmd_test]
    # # log_options
    # def test(*args)
    #   # update_config!
    #   perform('test', 'test', args)
    # end
  end
end
