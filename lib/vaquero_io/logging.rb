# Copyright information in version.rb
#
module VaqueroIo
  # misc methods and classes
  module Logging
    # send log info to both console and log file
    class MultiLogger
      def initialize(*targets)
        @targets = targets
      end

      %w(log debug info warn error fatal unknown).each do |m|
        define_method(m) do |*args|
          @targets.map { |t| t.send(m, *args) }
        end
      end
    end

    def self.stdout_logger
      # Log level and format for stdout message
      log = Logger.new(STDOUT)
      log.level = VaqueroIo::DEFAULT_LOG_LEVEL
      log.progname = VaqueroIo::APP_NAME
      log.formatter = proc do |severity, _datetime, _progname, msg|
        "#{severity.capitalize} > #{msg}\n"
      end
      log
    end

    def self.file_logger
      mode = ENV['VAQUEROIO_OVERWRITE_LOGS'].to_s.downcase == 'true' ? 'wb' : 'ab'
      FileUtils.mkdir_p(File.dirname(VaqueroIo::LOG_FILE))
      file = File.open(File.expand_path(VaqueroIo::LOG_FILE), mode)
      file.sync = true
      log = Logger.new(file)
      log.level = VaqueroIo::DEFAULT_LOG_LEVEL
      log.progname = VaqueroIo::APP_NAME
      log
    end

    def self.remote_logger
      if ENV['VAQUEROIO_REMOTE_LOGGER']
        log = VaqueroIo::Logging.send(ENV['VAQUEROIO_REMOTE_LOGGER'])
        log.level = VaqueroIo::DEFAULT_LOG_LEVEL
        log.progname = VaqueroIo::APP_NAME
      end
      log
    end

    def self.papertrail
      require 'remote_syslog_logger'
      RemoteSyslogLogger.new(ENV['VAQUEROIO_PAPERTRAIL_URL'], ENV['VAQUEROIO_PAPERTRAIL_PORT'])
    end

    def self.loggly
      require 'logglier'
      Logglier.new(ENV['VAQUEROIO_LOGGLY_URL'], threaded: true)
    end
  end
end
