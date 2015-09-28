# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Create < VaqueroIo::Command::Base
      include VaqueroIo::ValidateUtils
      # Invoke the command.
      def call
        fail StandardError, 'must specify environment paramters' if args.empty?
        create_env_cmd(VaqueroIo::Platform.new)
      end

      private

      def create_env_cmd(pf)
        if pf.environments.assoc(args[0])
          provision(pf) if validate_platform(pf)
          puts "Successfully created #{args[0]} #{options}"
        else
          fail ArgumentError, "#{args[0]} environment not found"
        end
      end

      def provision(pf)
        plugin = VaqueroIo::ProviderPlugin.new(pf.platform['provider'], pf.platform['product'])
        plugin.create(pf.environments[args[0]], options, auth_hash)
      end

      def auth_hash
        h = {}
        h['PUSER'] = ENV['VAQUEROIO_PUSER']
        h['PPASS'] = ENV['VAQUEROIO_PPASS']
        h['NUSER'] = ENV['VAQUEROIO_NUSER']
        h['NPASS'] = ENV['VAQUEROIO_NPASS']
        h
      end
    end
  end
end
