# Copyright information in version.rb
#
require 'vaquero_io/command'

module VaqueroIo

  module Command

    # Command to run a single action one or more instances.
    #
    # @author Fletcher Nichol <fnichol@nichol.ca>
    class Show < VaqueroIo::Command::Base

      # Invoke the command.
      def call
        if options[:config_only]
          puts "vaquero_io running config:\n"
          ENV_VARS.each { |v| puts "#{v}: #{ENV[v]}" }
        end

      end
    end
  end
end
