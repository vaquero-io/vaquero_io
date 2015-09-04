# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # show command
    class Show < VaqueroIo::Command::Base
      include CommandLineReporter
      include VaqueroIo::ShowUtils
      # Invoke the command.
      def call
        show_all(VaqueroIo::Platform.new) if args.empty?
        show_commands
        ENV_VARS.each { |v| puts "#{v}: #{ENV[v]}" } if options[:config_env]
      end

      def show_commands
        show_infra_cmd(VaqueroIo::Platform.new) if args[0] == 'infra'
        show_env_cmd(VaqueroIo::Platform.new) if args[0] == 'env'
      end

      def show_infra_cmd(pf)
        if args[1]
          if pf.infrastructure.assoc(args[1])
            show_infra(pf, args[1])
          else
            fail ArgumentError, "#{args[1]} infrastructure not found"
          end
        else
          show_infra(pf)
        end
      end

      def show_env_cmd(pf)
        if pf.environments.assoc(args[1])
          show_env(pf, args[1])
        else
          fail ArgumentError, "#{args[1]} environment not found"
        end
      end
    end
  end
end
