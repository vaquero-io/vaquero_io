# Copyright information in version.rb
#
require 'vaquero_io/command'

module VaqueroIo
  # included in Command module
  module Command
    # command
    class Create < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        puts 'create command'
      end
    end
  end
end
