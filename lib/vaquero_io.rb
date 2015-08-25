# Copyright information in version.rb
#
require 'thor'
require 'pathname'
require 'benchmark'
require 'logger'
require 'fileutils'
require 'dotenv'
require 'erubis'
# require 'English'
require 'vaquero_io/version'
require 'vaquero_io/config'
require 'vaquero_io/messages'
require 'vaquero_io/logging'
require 'vaquero_io/plugin'
require 'vaquero_io/provider'
require 'vaquero_io/providerplugin'
require 'vaquero_io/platform'
require 'vaquero_io/build'
#
module VaqueroIo
  # global variables and environment initialization
  class << self
    attr_accessor :config
    attr_accessor :logger
    attr_accessor :elapsed

    def source_root
      @source_root ||= Pathname.new(File.expand_path('../../', __FILE__))
    end
  end

  def self.with_logging
    yield
  rescue => err
    VaqueroIo.logger.fatal(err.message)
    VaqueroIo.config.write_log.fatal(err)
    exit 1
  end

  def self.setup_logging
    # send logger messages to both console and file storage. Use Remote if defined
    # Backtrace only to written
    @logger = VaqueroIo::Logging::MultiLogger.new(VaqueroIo.config.stdout_log,
                                                  VaqueroIo.config.local_log,
                                                  VaqueroIo.config.remote_log)
  end
end

# Initialize running configuration and the base logger
VaqueroIo.config = VaqueroIo::Config.new
VaqueroIo.setup_logging
