# Copyright information in version.rb
#
module VaqueroIo
  # environment variables. Modify .env file to use
  ENV_VARS = %w(VAQUEROIO_OVERWRITE_LOGS
                VAQUEROIO_REMOTE_LOGGER
                VAQUEROIO_DEFAULT_PROVIDER
                VAQUEROIO_DEFAULT_ENV)
  ENV_FILE = '.vaquero_io/.env'.freeze
  ENV_TEMPLATE = 'lib/vaquero_io/templates/.env'

  # Log defaults
  DEFAULT_LOG_LEVEL = Logger::INFO
  LOG_FILE = '.vaquero_io/logs/vaquero_io.log'.freeze

  # plugin conventions
  PROVIDERGEMPATTERN = /^(vaquero_io)/
  PROVIDERFILE = 'Providerfile.yml'
  PROVIDERS_PATH = "#{File.dirname(__FILE__).chomp('vaquero_io')}providers/"
  LIST_PLUGINS_PATH = "#{PROVIDERS_PATH + '**/Providerfile.yml'}"
  TEMPLATE_PROVIDER = "templates/#{PROVIDERFILE}.tt"
  TMP_INSTALL_FOLDER = "#{Dir.pwd}/tmp-providers"
  TMP_INSTALL_PROVIDER = "#{TMP_INSTALL_FOLDER}/#{PROVIDERFILE}"
  ENVIRONMENTFILE = 'environments/'

  # provider platform templates
  PLATFORMTEMPLATE = 'lib/vaquero_io/templates/platform.yml.erb'
  PLATFORMFILE = 'platform.yml'

  # system variables
  PUTENV_PROVIDER = 'PUTENV_PROVIDER'

  # running app config
  class Config
    attr_reader :root_dir

    attr_accessor :stdout_log, :local_log, :remote_log
    attr_accessor :write_log
    attr_reader :use_remote_log

    def initialize
      # @loader         = options.fetch(:loader) { Kitchen::Loader::YAML.new }
      local_config
      @root_dir       = Dir.pwd
      @stdout_log     = VaqueroIo::Logging.stdout_logger
      @local_log      = VaqueroIo::Logging.file_logger
      @remote_log     = VaqueroIo::Logging.remote_logger
      @write_log      = VaqueroIo::Logging::MultiLogger.new(@local_log, @remote_log)
    end

    private

    def local_config
      unless File.exist?(VaqueroIo::ENV_FILE)
        FileUtils.mkdir_p(File.dirname(VaqueroIo::ENV_FILE))
        FileUtils.cp(VaqueroIo.source_root + VaqueroIo::ENV_TEMPLATE, VaqueroIo::ENV_FILE)
      end
      # loads ENV variables defined in .env file
      Dotenv.load(VaqueroIo::ENV_FILE)
    end
  end
end
