require 'thor'
require 'putenv/messages'

# Refer to README.md for use instructions
module Putenv
  # Start of main CLI
  class CLI < Thor
    package_name 'putenv'
    map '--version' => :version
    map '-v' => :version

    desc 'version', DESC_VERSION
    def version
      puts VERSION
    end
  end
end
