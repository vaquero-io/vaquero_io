# Copyright information in version.rb
#
module VaqueroIo
  # main Command module definition
  module Command
    # base class used in command files
    class Base
      attr_reader :args
      attr_reader :options
      attr_reader :action
      attr_reader :help

      def initialize(cmd_args, cmd_options, options = {})
        @args = cmd_args
        @options = cmd_options
        @action = options.fetch(:action, nil)
        @help = options.fetch(:help, -> { 'No help provided' })
      end
    end
  end
end
