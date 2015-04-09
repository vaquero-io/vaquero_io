require 'resolv'
require 'uri'
require 'vaquero_io/provision'

module VaqueroIo
  # rubocop:disable ClassLength
  class Platform
    include VaqueroIo::Platform::Provision

    attr_accessor :provider
    attr_accessor :product
    attr_accessor :product_provider, :product_provider_version
    attr_accessor :environments
    attr_accessor :nodename
    attr_accessor :components
    attr_accessor :required
    attr_accessor :env_definition

    # rubocop:disable MethodLength, LineLength
    def initialize(provider = nil)
      @provider = provider
      fail unless platform_files_exist?
      platform = YAML.load_file(PLATFORMFILE).fetch('platform')
      @product = platform['product']
      @product_provider = platform['provider']

      # Lazy provider loading if we weren't given one...
      if @provider.nil?
        @provider = VaqueroIo::Provider.new(@product_provider)
        # re-test platform health
        fail unless platform_files_exist?
      end

      @product_provider_version = platform['plugin_version']
      @environments = platform['environments']
      @nodename = platform['nodename']
      @components = platform['components']
      @required = {}
      @provider.definition['structure']['require'].each do |required_file|
        @required[required_file] = YAML.load_file(@provider.definition['structure'][required_file]['path'] + required_file + '.yml').fetch(required_file)
      end
    end
    # rubocop:enable MethodLength, LineLength

    # rubocop:disable MethodLength, LineLength, CyclomaticComplexity, PerceivedComplexity
    def healthy?(env = '')
      health = ''
      health += (FAIL_PROVIDER + "\n") if @provider.definition['name'] != @product_provider
      puts WARN_PROVIDER_VERSION if @provider.definition['version'] != @product_provider_version
      health += (FAIL_EMPTY_ENVIRONMENTS + "\n") unless @environments.all?
      @environments.each do |e|
        health += (FAIL_MISSING_ENV + e + "\n") unless File.file?(ENVIRONMENTFILE + e + '.yml')
      end if @environments.all?
      health += (FAIL_EMPTY_NODENAME + "\n") unless @nodename.all?

      # confirm that the platform definition references all required files
      @provider.definition['structure']['require'].each do |required_file|
        @components.each do |_param, value|
          health += (FAIL_REQUIRED_FILES + required_file + "\n") unless value.key?(required_file)
          # TODO: Validate that the value for the required file key actually matches a defined key value
        end
        # Validate required files against template
        health += validate(@provider.definition['structure'][required_file]['params'], @required[required_file])
      end
      # Validate platform against template
      health += validate(@provider.definition['structure']['platform']['params'], @components)

      # TODO: if an environment is specified then we are checking the health of the environment rather than platform
      puts 'list nodes' unless env.empty?
      if health.length > 0
        puts health + "\n#{health.lines.count} platform offense(s) detected"
        false
      else
        true
      end
    end
    # rubocop:enable MethodLength, LineLength, CyclomaticComplexity, PerceivedComplexity

    # rubocop:disable MethodLength, LineLength
    def environment(env)
      return unless healthy?
      build_env = YAML.load_file(ENVIRONMENTFILE + env + '.yml').fetch(env)
      @components.each do |component, _config|
        begin
          build_env['components'][component].merge!(@components[component]) { |_key, v1, _v2| v1 } unless build_env['components'][component].nil?
        rescue => error
          puts "ERROR: build_env: could not merge component \"#{component}\" for environment \"#{env}\"!"
          raise error
        end
      end
      build_env['components'].each do |component, config|
        @required.each do |required_item, _values|
          build_env['components'][component][required_item] = @required[required_item][build_env['components'][component][required_item]]
        end
        config['component_role'] = config['component_role'].gsub('#', component) if config['component_role']
      end
      @env_definition = {}
      build_env['components'].each do |component, config|
        nodes = []
        (1..config['count']).each do |n|
          nodes << node_name(env, component, n)
        end
        # build_env['components'][component].merge!(@components[component])
        build_env['components'][component]['nodes'] = nodes
      end
      @env_definition = build_env
    end
    # rubocop:enable MethodLength, LineLength

    private

    # rubocop:disable MethodLength
    def node_name(env, component, instance)
      name = ''
      @nodename.each do |i|
        case i
        when 'environment'
          name += env
        when 'component'
          name += component
        when 'instance'
          name += instance.to_s.rjust(2, '0')
        else
          name += i
        end
      end
      name
    end
    # rubocop:enable MethodLength

    # rubocop:disable MethodLength, LineLength, CyclomaticComplexity, PerceivedComplexity
    def validate(templatefile, definitionfile)
      health = ''
      templatefile.each do |param, value|
        definitionfile.each do |component, keys|
          case
          when value['array']
            if keys[param].class == Array
              keys[param].each do |i|
                health += "Validation error: #{component}:#{param}\n" unless valid?(i, value['array'])
              end
            else
              health += "Validation error: #{component}:#{param}\n"
            end
          when value['hash']
            keys[param].each do |k, v|
              health += "Validation error: #{component}:#{param}\n" unless valid?(v, value['hash'][k])
            end
          else
            health += "Validation error: #{component}:#{param}\n" unless valid?(keys[param], value)
          end
        end
      end
      health
    end
    # rubocop:enable MethodLength, LineLength, CyclomaticComplexity, PerceivedComplexity

    # rubocop:disable MethodLength, DoubleNegation, CyclomaticComplexity, PerceivedComplexity, LineLength
    def valid?(value, validate)
      if value.nil?
        false
      else
        case validate['type']
        when 'integer'
          rng = validate['range'].split('..').map { |d| Integer(d) }
          (value.class != Fixnum) ? false : Range.new(rng[0], rng[1]).member?(value)
        when 'string'
          (value.class != String) ? false : value.match(Regexp.new(validate['match']))
        when 'IP'
          (value.class != String) ? false : Resolv::IPv4::Regex.match(value)
        when 'URL'
          (value.class != String) ? false : value.match(URI.regexp)
        when 'boolean'
          !!value == value
        else
          false
        end
      end
    end
    # rubocop:enable MethodLength, DoubleNegation, CyclomaticComplexity, PerceivedComplexity, LineLength

    # rubocop:disable LineLength
    def platform_files_exist?
      fail(IOError, MISSING_PLATFORM) unless File.file?(PLATFORMFILE)
      unless @provider.nil? # We can't check that everything's present yet...
        @provider.definition['structure']['require'].each do |required_file|
          fail(IOError, MISSING_PLATFORM + required_file) unless File.file?(@provider.definition['structure'][required_file]['path'] + required_file + '.yml')
        end
      end
      true
    end
    # rubocop:enable LineLength
  end
  # rubocop:enable ClassLength
end
