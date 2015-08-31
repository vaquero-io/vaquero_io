# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # init command
    class Init < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        fail IOError, 'platform.yml already exists' if File.exist?(VaqueroIo::PLATFORMFILE)
        fail IOError, 'init expects a single argument' if args.count != 1
        VaqueroIo::ProviderPlugin.new(options[:provider], args[0]).create_platform_template
      end
    end
  end
end
