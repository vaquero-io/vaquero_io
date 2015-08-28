module VaqueroIo
  # ProviderPlugin class definition
  class ProviderPlugin
    attr_accessor :app_name

    def initialize(use_provider, app_name)
      resolve_provider(use_provider)
      @app_name = app_name
    end

    def create_platform_template
      providerfile = definition['provider']
      puts providerfile.to_yaml
      puts '___'
      platform_file(providerfile)
      required_files(providerfile['require'], providerfile)
    end

    private

    def platform_file(providerfile)
      erbfile = Erubis::Eruby.new(File.read(VaqueroIo.source_root + VaqueroIo::PLATFORMTEMPLATE))
      puts erbfile.result(binding)
      writefilename = providerfile['platform']['path'].to_s + VaqueroIo::PLATFORMFILE
      puts writefilename
      # File.write(VaqueroIo::PLATFORMFILE, eruby.result(binding))
    end

    def required_files(list, providerfile)
      list.each do |f|
        puts f
      end
    end

    def resolve_provider(provider)
      provider = ENV['VAQUEROIO_DEFAULT_PROVIDER'] if provider.nil? || provider.empty?
      if Gem::Dependency.new(provider).matching_specs.last
        require provider
        extend ProviderPluginExtensions
      else
        fail IOError, 'Cannot load the Provider Gem specified'
      end
    end
  end
end
