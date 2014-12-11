require 'thor'
require 'putenv/messages'
require 'putenv/provider'

# Refer to README.md for use instructions
module Putenv
  # Start of main CLI
  class CLI < Thor
    package_name 'putenv'
    map '--version' => :version
    map '-v' => :version

    desc 'version, -v', DESC_VERSION
    def version
      puts VERSION
    end

    # subcommand in Thor called as registered class
    register(Putenv::Provider, 'provider', 'provider COMMAND', DESC_PROVIDER)
  end
end
