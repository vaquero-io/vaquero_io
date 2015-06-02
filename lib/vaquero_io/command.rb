# Copyright information in version.rb
#
module VaqueroIo

  module Command

    class Base

      def initialize(cmd_args, cmd_options, options = {})
        @args = cmd_args
        @options = cmd_options
        @action = options.fetch(:action, nil)
        @help = options.fetch(:help, -> { "No help provided" })
      end

      private

      attr_reader :args
      attr_reader :options
      attr_reader :action
      attr_reader :help

    end

    module RunAction

      def run_action(action, instances, *args)

        puts "action: #{action}"
        puts "instances: #{instances}"
        puts "args: #{args}"
      end
    end
  end
end