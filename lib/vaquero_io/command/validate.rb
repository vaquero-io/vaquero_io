# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Validate < VaqueroIo::Command::Base
      include VaqueroIo::ValidateUtils
      # Invoke the command.
      def call
        puts VaqueroIo::HEALTHY if validate_platform(VaqueroIo::Platform.new)
      end
    end
  end
end
