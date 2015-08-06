# Copyright information in version.rb
#
require 'vaquero_io/command'

module VaqueroIo
  # included in Command module
  module Command
    # command
    class Show < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        # its complaining about guard clause but this is only partly done
        # rubocop:disable all
        if options[:config_only]
          puts "vaquero_io running config:\n"
          ENV_VARS.each { |v| puts "#{v}: #{ENV[v]}" }
        end
        # rubocop:enable all
      end
    end
  end
end
