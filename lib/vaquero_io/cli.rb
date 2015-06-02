# Copyright information in version.rb
#
require 'thor'
require 'vaquero_io'

module VaqueroIo
  # CLI Interface
  class CLI < Thor


    module RunCommands

      def do_command(task, command, args = nil)
        VaqueroIo.elapsed = Benchmark.measure do
          puts "task: #{task}, command: #{command}, args: #{args}"
          require "vaquero_io/command/#{command}"
          parameters = {
              action: task,
              help: -> { help(task) }
          }
          cmd = VaqueroIo::Command.const_get(Thor::Util.camel_case(command))
          cmd.new(args, options, parameters).call
        end
        VaqueroIo.logger.info "Elapsed #{VaqueroIo::Logging.duration(VaqueroIo.elapsed.real)}"
      end
    end
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

    include RunCommands

    def initialize(*args)
      super
      # puts args[2][:current_command][0]
      $stdout.sync = true
    end

    desc 'version, -v', DESC[:cmd_version]
    map %w(-v --version) => :version
    def version
      puts "vaquero_io #{VaqueroIo::VERSION}"
      VaqueroIo.logger.info 'hello'
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
    desc 'show [ENV|{all}]', DESC[:cmd_show]
    method_option :test,
                  :aliases => "-t",
                  :type => :boolean,
                  :desc => "Include serverspec test results"
    method_option :config_only,
                  :aliases => "-c",
                  :type => :boolean,
                  :desc => "Show running configuration"
    # log_options
    def show(*args)
      # update_config!
      do_command('show', 'show', args)
    end
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
