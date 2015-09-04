# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # command
    class Destroy < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        puts 'destroy command'
      end
    end
  end
end
