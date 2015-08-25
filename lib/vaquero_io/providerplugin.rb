module VaqueroIo
  # ProviderPlugin class definition
  class ProviderPlugin
    attr_accessor :definition

    def initialize(use_provider)
      resolve_provider(use_provider)
    end

    def create_platform_template
      platformdef = self.definition['provider']['platform']
      puts platformdef.to_yaml
      platform_file(platformdef)
    end

    private

    def platform_file(d)
      input = File.read(PLATFORMFILE)
      eruby = Erubis::Eruby.new(input)
      puts eruby.src

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
