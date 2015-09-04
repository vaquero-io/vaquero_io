# Copyright information in version.rb
#
require 'thor'
require 'vaquero_io'
module VaqueroIo
  # CLI Interface
  class CLI < Thor
    # command files in Command folder
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
                  desc: 'Specify vaquero_io provider gem (or or .env)'
    def init(*args)
      do_command('init', 'init', args)
    end

    # desc 'validate [ENV]|all', DESC[:cmd_validate]
    # method_options %w( provider -p ) => :string
    # def validate(env = '')
    #   provider = options[:provider] ? VaqueroIo::Provider.new(options[:provider]) : nil
    #   puts HEALTHY if VaqueroIo::Platform.new(provider).healthy?(env)
    # end

    desc 'show [INFRA|ENV|{all}]', 'Print current platform state information'
    method_option :config_env,
                  aliases: '-c',
                  type: :boolean,
                  desc: 'Show running ENV configuration'
    def show(*args)
      do_command('show', 'show', args)
    end

    desc 'create ENV {-r ROLE {-n NODE#..#}}',
         'Provision and boot strap an ENV, ROLE, or NODE(s)'
    method_option :role,
                  aliases: '-r',
                  type: :boolean,
                  desc: 'Create only specific ROLE within ENV'
    method_option :node,
                  aliases: '-n',
                  type: :boolean,
                  desc: 'Create only node(#range) in ROLE within ENV'
    def create(*args)
      do_command('create', 'create', args)
    end

    desc 'destroy ENV {-r ROLE {-n NODE#..#}}',
         'Delete or de-provision an ENV, ROLE, or NODE(s)'
    method_option :role,
                  aliases: '-r',
                  type: :boolean,
                  desc: 'Delete only specific ROLE within ENV'
    method_option :node,
                  aliases: '-n',
                  type: :boolean,
                  desc: 'Delete only node(#range) in ROLE within ENV'
    def destroy(*args)
      do_command('destroy', 'destroy', args)
    end

    desc 'validate [ENV|{all}]', 'Test providerfile validations against full platform or ENV'
    def validate(*args)
      do_command('validate', 'validate', args)
    end
    #
    # desc 'test [ENV|{all}]', DESC[:cmd_test]
    # def test(*args)
    #   do_command('test', 'test', args)
    # end
    # register(VaqueroIo::Plugin, 'plugin', 'plugin COMMAND', DESC_PLUGIN)
    # register(VaqueroIo::Build, 'build', 'build TARGET', DESC_BUILD)
  end
end
