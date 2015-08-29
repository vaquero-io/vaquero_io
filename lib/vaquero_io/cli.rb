# Copyright information in version.rb
#
require 'thor'
require 'vaquero_io'
module VaqueroIo
  # CLI Interface
  class CLI < Thor
    # comand files in Command folder
    module RunCommands
      # rubocop:disable AbcSize
      def do_command(task, command, args = nil)
        VaqueroIo.elapsed = Benchmark.measure do
          require "vaquero_io/command/#{command}"
          parameters = {
            action: task,
            help: -> { help(task) }
          }
          cmd = VaqueroIo::Command.const_get(Thor::Util.camel_case(command))
          cmd.new(args, options, parameters).call
        end
        VaqueroIo.logger.info "#{task}: #{VaqueroIo::Logging.duration(VaqueroIo.elapsed.real)}"
      end
      # rubocop:enable AbcSize
    end

    include RunCommands

    def initialize(*args)
      super
      $stdout.sync = true
    end

    desc 'version, -v', 'Print vaquero_io version information'
    map %w(-v --version) => :version
    def version
      puts "vaquero_io #{VaqueroIo::VERSION}"
    end

    desc 'provider {options}', 'Manage Provider plugins and definition files'
    method_option :list,
                  aliases: '-l',
                  type: :boolean,
                  default: false,
                  desc: 'List all installed provider gems'
    method_option :discover,
                  aliases: '-d',
                  type: :boolean,
                  default: false,
                  desc: 'List all vaquero_io provider gems on RubyGems'
    def provider(*args)
      do_command('provider', 'provider', args)
    end

    desc 'init PLATFORM', 'Create new platform definition files based on specified Provider'
    method_option :provider,
                  aliases: '-p',
                  type: :string,
                  desc: 'Specify vaquero_io provider gem'
    def init(*args)
      do_command('init', 'init', args)
    end

    desc 'validate [ENV]|all', DESC[:cmd_validate]
    method_options %w( provider -p ) => :string
    def validate(env = '')
      provider = options[:provider] ? VaqueroIo::Provider.new(options[:provider]) : nil
      puts HEALTHY if VaqueroIo::Platform.new(provider).healthy?(env)
    end

    desc 'show [ENV|{all}]', 'Print current platform state information'
    method_option :test,
                  aliases: '-t',
                  type: :boolean,
                  desc: 'Include serverspec test results'
    method_option :config_only,
                  aliases: '-c',
                  type: :boolean,
                  desc: 'Show running configuration'
    def show(*args)
      do_command('show', 'show', args)
    end

    desc 'create ENV [-c COMPONENT [-n NODE#..#]]',
         'Provision and boot strap an ENV, COMPONENT, or NODE(s)'
    def create(*args)
      do_command('create', 'create', args)
    end
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
    # register(VaqueroIo::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    register(VaqueroIo::Build, 'build', 'build TARGET', DESC_BUILD)
  end
end
