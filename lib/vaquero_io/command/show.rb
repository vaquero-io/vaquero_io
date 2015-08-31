# Copyright information in version.rb
#
module VaqueroIo
  # included in Command module
  module Command
    # show command
    class Show < VaqueroIo::Command::Base
      # Invoke the command.
      def call
        if options[:config_only]
          puts "vaquero_io running config:\n"
          ENV_VARS.each { |v| puts "#{v}: #{ENV[v]}" }
        else
          puts 'display'
        end
      end
    end
  end
end
