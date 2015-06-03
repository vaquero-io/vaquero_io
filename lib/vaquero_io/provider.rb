module VaqueroIo
  # comment
  class Provider
    attr_accessor :provider
    attr_accessor :definition

    # rubocop:disable all
    def initialize(use_provider)
      @provider = resolve_provider(use_provider)
      @definition = YAML.load_file(PROVIDERS_PATH + @provider + '/' + PROVIDERFILE).fetch('provider')
      require PROVIDERS_PATH + @provider + '/' + @provider.gsub('-', '_') + '.rb'
    end
    # rubocop:enable LineLength

    # rubocop:disable MethodLength, LineLength
    def new_definition
      if File.exist?('platform.yml')
        fail(IOError, PLATFORM_EXISTS)
      else
        Pathname.glob(PROVIDERS_PATH + @provider + '/templates/*.yml').each do |prov|
          path = @definition['structure'][File.basename(prov, '.yml')]['path']
          if @definition['structure'][File.basename(prov, '.yml')]['path'].nil?
            path = ''
          else
            unless File.directory?(@definition['structure'][File.basename(prov, '.yml')]['path'])
              FileUtils.mkdir(@definition['structure'][File.basename(prov, '.yml')]['path'])
            end
          end
          FileUtils.cp(prov, path + File.basename(prov))
        end
        puts MSG_NEW_SUCCESS
      end
    end
    # rubocop:enable all

    private

    def resolve_provider(provider)
      if provider.nil?
        ENV[PUTENV_PROVIDER].nil? ? fail(IOError, NO_PROVIDER) : ENV[PUTENV_PROVIDER]
      else
        provider
      end
    end

    # def resolve_provider(provider)
    #   if provider.nil?
    #     if ENV['VAQUEROIO_DEFAULT_PROVIDER'].nil?
    #       raise ArgumentError, FERR[:fatal_no_provider]
    #     else
    #       provider = ENV['VAQUEROIO_DEFAULT_PROVIDER']
    #     end
    #   end
    #   require provider
    #   provider
    # rescue LoadError
    #   install_gem(provider)
    # end
    #
    #
    # def install_gem(provider)
    #   unless (system "gem install #{provider}")
    #     raise ArgumentError, FERR[:fatal_no_provider]
    #   end
    #   Gem.clear_paths
    #   require provider
    #   provider
    # end
  end
end
