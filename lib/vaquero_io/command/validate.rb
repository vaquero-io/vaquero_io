# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Validate < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        puts 'validate command'
      end
    end
  end
end
