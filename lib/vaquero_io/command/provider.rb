# Copyright information in version.rb
#
require 'vaquero_io/command'

module VaqueroIo
  # included in Command module
  module Command
    # command processor
    class Provider < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        # its complaining about guard clause but this is only partly done
        puts args.first
      end
    end
  end
end
