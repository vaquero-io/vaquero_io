module VaqueroIo
  # ProviderPlugin class definition
  class ProviderPlugin
    attr_accessor :app_name

    def initialize(use_provider, app_name)
      resolve_provider(use_provider)
      @app_name = app_name
    end

    def create_platform_template
      platform_file(definition['provider'])
      required_files(definition['provider']['require'], definition['provider'])
    end

    private

    def platform_file(providerfile)
      erbfile = parse_template(VaqueroIo::PLATFORMTEMPLATE, providerfile)
      writetemplate(providerfile['platform']['path'].to_s, VaqueroIo::PLATFORMFILE, erbfile)
    end

    def required_files(list, providerfile)
      list.each do |f|
        erbfile = parse_template(VaqueroIo::INFRASTRUCTURETEMPLATE, providerfile, f)
        writetemplate(providerfile[f]['path'].to_s, f + '.yml', erbfile)
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

    def parse_template(template, providerfile, f = nil)
      templatefile = VaqueroIo.source_root + template
      Erubis::Eruby.new(File.read(templatefile)).result(binding)
    end

    def writetemplate(filepath, filename, template)
      writefile = filename
      unless filepath.empty?
        Dir.mkdir(filepath) unless File.exist?(filepath)
        writefile = File.join(filepath, writefile)
      end
      File.write(writefile, template)
    end
  end
end
