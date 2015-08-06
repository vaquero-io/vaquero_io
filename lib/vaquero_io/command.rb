# Copyright information in version.rb
#
module VaqueroIo
  # main Command module definition
  module Command
    # base class used in command files
    class Base
      def initialize(cmd_args, cmd_options, options = {})
        @args = cmd_args
        @options = cmd_options
        @action = options.fetch(:action, nil)
        @help = options.fetch(:help, -> { 'No help provided' })
      end

      private

      attr_reader :args
      attr_reader :options
      attr_reader :action
      attr_reader :help
      # TODO: additional work needed here to account for multiple related commands in same file
    end
    # module for including multiple related commands in same file
    module RunAction
      def run_action(action, instances, *args)
        puts "action: #{action}"
        puts "instances: #{instances}"
        puts "args: #{args}"
      end
    end
  end
end
