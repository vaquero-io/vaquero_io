# require 'resolv'
# require 'uri'

module VaqueroIo
  # Platform class definition
  class Platform
    attr_accessor :platform
    attr_accessor :definition
    attr_accessor :infrastructure
    attr_accessor :environments
    attr_accessor :pre_env

    def initialize(provider = nil)
      @platform = load_yaml(VaqueroIo::PLATFORM + '.yml', VaqueroIo::PLATFORM)
      @definition = load_provider_definition(provider)
      @infrastructure = load_infrastructure(VaqueroIo::INFRASTRUCTURE)
      @environments = load_environments(VaqueroIo::ENVIRONMENTS)

      merge_platform
      substitute_infrastructure unless @platform[VaqueroIo::INFRASTRUCTURE][0].nil?
      refactor_environments
    end

    private

    def load_provider_definition(provider)
      provider ? use_provider = provider : use_provider = @platform['provider']
      plugin = VaqueroIo::ProviderPlugin.new(use_provider, @platform['product'])
      fail StandardError, "Incorrect provider gem version #{plugin.version}" unless \
        plugin.version == @platform['plugin_version']
      plugin.definition['provider']
    end

    def load_infrastructure(infra)
      load_multiple(@platform[infra], infra) unless @platform[infra][0].nil?
    end

    def load_environments(env)
      fail StandardError, 'Must define at least one environment' if @platform[env][0].nil?
      load_multiple(@platform[env], env)
    end

    def load_multiple(list, location)
      returnhash = {}
      list.each do |f|
        filetoload = File.join(location, f + '.yml')
        returnhash[f] = load_yaml(filetoload, f)
      end
      returnhash
    end

    def merge_platform
      # for each role defined by the platform definition
      @platform['roles'].each do |role, _v|
        # for each environment defined in the platform definition
        @platform['environments'].each do |e|
          # merge into the environment role any platform definition not overridden
          environments[e][role].merge!(platform['roles'][role]) { |_key, v1, _v2| v1 }
        end
      end
      @pre_env = Marshal.load(Marshal.dump(@environments))
    end

    # Still fails ABC even when I move the inner interators to sep method
    # rubocop:disable AbcSize
    def substitute_infrastructure
      # for each environment defined in the platform definition
      @environments.each do |e, roles|
        # for each role defined in the environment
        roles.each do |role, _keys|
          # replace infrastructure tags with the respective keys
          @platform['infrastructure'].each do |infra|
            # fails where infra defined in platform but not found in role
            fail StandardError, "#{infra} not found in #{e} environment, #{role} role" \
            unless @environments[e][role].key?(infra)
            @environments[e][role][infra] = @infrastructure[infra][@environments[e][role][infra]]
          end
        end
      end
    end
    # rubocop:enable AbcSize

    def refactor_environments
      # for each environment
      @environments.each do |e, roles|
        # for each role defined in the environment
        roles.each do |role, _keys|
          add_nodename(e, role)
          # substitute role name for # in cmrunlist entries
          runlist_substitute(e, role)
        end
      end
      # copy last platform class environment build to log directory
      File.write(VaqueroIo::LASTENV_FILE, @environments.to_yaml)
    end

    def add_nodename(environment, role)
      nodename = ''
      @platform['nodename'].each do |i|
        nodename += environment if i == 'environment'
        nodename += role if i == 'role'
        nodename += i unless i == 'environment' || i == 'role'
      end
      @environments[environment][role]['nodename'] = nodename
    end

    def runlist_substitute(environment, role)
      runlist = []
      @environments[environment][role]['cmrunlist'].count.times do |r|
        runlist[r] = @environments[environment][role]['cmrunlist'][r].gsub('#', role)
      end
      @environments[environment][role]['cmrunlist'] = runlist
    end

    def load_yaml(filename, key)
      fail IOError, "#{filename} not found" unless File.file?(filename)
      YAML.load_file(filename).fetch(key)
    end
  end
end
