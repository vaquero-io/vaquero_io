# Copyright information in version.rb
#
require 'vaquero_io/command'
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Init < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        VaqueroIo::ProviderPlugin.new(options[:provider]).create_platform_template
      end
    end
  end
end
