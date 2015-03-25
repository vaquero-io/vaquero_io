require 'putenv'

module Putenv
  # wrapper to assist aruba in single process execution
  class Runner
    # rubocop:disable LineLength
    def initialize(argv, stdin = STDIN, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv, @stdin, @stdout, @stderr, @kernel = argv, stdin, stdout, stderr, kernel
    end
    # rubocop:enable LineLength

    # rubocop:disable MethodLength
    def execute!
      exit_code = begin
        $stderr = @stderr
        $stdin = @stdin
        $stdout = @stdout

        Putenv::CLI.start(@argv)

        # Thor::Base#start does not have a return value
        # assume success if no exception is raised.
        0
      rescue StandardError => err
        # The ruby interpreter would pipe this to STDERR and
        # exit 1 in the case of an unhandled exception
        b = err.backtrace
        b.unshift("#{b.shift}: #{err.message} (#{err.class})")
        @stderr.puts(b.map { |s| "\tfrom #{s}" }.join("\n"))
        1
      ensure
        # put them back.
        $stderr = STDERR
        $stdin = STDIN
        $stdout = STDOUT
      end
      # Proxy exit code back to the injected kernel.
      @kernel.exit(exit_code)
    end
    # rubocop:enable MethodLength
  end
end
