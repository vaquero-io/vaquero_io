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

    include RunCommands

    def initialize(*args)
      super
      $stdout.sync = true
    end

    desc 'version, -v', DESC[:cmd_version]
    map %w(-v --version) => :version
    def version
      puts "vaquero_io #{VaqueroIo::VERSION}"
      VaqueroIo.logger.info 'hello'
    end

    desc 'init', DESC[:cmd_init]
    method_options %w( provider -p ) => :string, required: true
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

    desc 'show [ENV|{all}]', DESC[:cmd_show]
    method_option :test,
                  :aliases => '-t',
                  :type => :boolean,
                  :desc => DESC[:cmd_show_test]
    method_option :config_only,
                  :aliases => '-c',
                  :type => :boolean,
                  :desc => DESC[:cmd_show_config_only]
    def show(*args)
      do_command('show', 'show', args)
    end
    # desc 'create ENV [-c COMPONENT [-n NODE#..#]]', DESC[:cmd_create]
    # def create(*args)
    #   do_command('create', 'create', args)
    # end
    #
    # desc 'validate [ENV|{all}]', DESC[:cmd_validate]
    # def validate(*args)
    #   do_command('validate', 'validate', args)
    # end
    #
    # desc 'set ENV', DESC[:cmd_set]
    # def set(*args)
    #   do_command('set', 'set', args)
    # end
    #
    # desc 'destroy ENV [-c COMPONENT [-n NODE#..#]]', DESC[:cmd_destroy]
    # def destroy(*args)
    #   do_command('destroy', 'destroy', args)
    # end
    #
    # desc 'test [ENV|{all}]', DESC[:cmd_test]
    # def test(*args)
    #   do_command('test', 'test', args)
    # end

    private

    def providerfile_present?

    end
  end
end
