require_relative 'spec_helper'
require 'vaquero_io'
# basic tests of initialized module
describe 'vaquero_io' do
  # samples of items defined during startup
  describe 'initial defaults and logging setup' do
    it '.source_root returns the root path of the gem' do
      expect(VaqueroIo.source_root).to eq Pathname.new(File.expand_path('../..', __FILE__))
    end

    # will likely make this overridable in .env at some point
    it 'sets DEFAULT_LOG_LEVEL to :info' do
      expect(VaqueroIo::DEFAULT_LOG_LEVEL).to eq Logger::INFO
    end

    it 'sets ENV_FILE to .vaquero_io/.env, which is frozen' do
      expect(VaqueroIo::ENV_FILE).to eq '.vaquero_io/.env'
      expect(VaqueroIo::ENV_FILE.frozen?).to eq true
    end

    it 'sets LOG_FILE to .vaquero_io/logs/vaquero_io.log, which is frozen' do
      expect(VaqueroIo::LOG_FILE).to eq '.vaquero_io/logs/vaquero_io.log'
      expect(VaqueroIo::LOG_FILE.frozen?).to eq true
    end

    it '.stdout_log and .file_log are Logger' do
      expect(VaqueroIo.config.stdout_log).to be_a Logger
      expect(VaqueroIo.config.local_log).to be_a Logger
    end

    it 'default logging should be to a VaqueroIo::Logging::MultiLogger' do
      expect(VaqueroIo.logger).to be_a VaqueroIo::Logging::MultiLogger
    end
  end
end
