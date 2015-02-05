require 'resolv'

module Putenv
  class Platform
    attr_accessor :provider
    attr_accessor :product
    attr_accessor :product_provider, :product_provider_version
    attr_accessor :environments
    attr_accessor :nodename
    attr_accessor :components
    attr_accessor :required

    def initialize(provider)
      @provider = provider
      fail unless platform_files_exist?
      platform = YAML.load_file(PLATFORMFILE).fetch('platform')
      @product = platform['product']
      @product_provider= platform['provider']
      @product_provider_version= platform['plugin_version']
      @environments = platform['environments']
      @nodename = platform['nodename']
      @components = platform['components']
      @required = {}
      @provider.definition['structure']['require'].each do |required_file|
        @required[required_file] = YAML.load_file(@provider.definition['structure'][required_file]['path'] + required_file + '.yml').fetch(required_file)
      end
    end

    def healthy?(env)
      health = ''
      health += FAIL_PROVIDER if @provider.definition['name'] != @product_provider
      puts WARN_PROVIDER_VERSION if @provider.definition['version'] != @product_provider_version
      health += FAIL_EMPTY_ENVIRONMENTS unless @environments.all?
      health += FAIL_EMPTY_NODENAME unless @nodename.all?
      @provider.definition['structure']['require'].each do |required_file|
        @components.each do |_param, value|
          health += (FAIL_REQUIRED_FILES + required_file) unless value.key?(required_file)
        end
      end
      # platform definition check
      @provider.definition['structure']['platform']['params'].each do |param, value|
        puts "platform param: #{param}"
        puts "should be: #{value}\n\n"

        @components.each do |component, keys|
          case
            when value['array']
              keys[param].each do |i|
                health += "Validation error: #{component}:#{param}" unless valid?(i,value['array'])
              end
            when value['hash']
              puts "#{value['hash']}"
            else
              health += "Validation error: #{component}:#{param}" unless valid?(keys[param],value)
          end
        end
      end
      puts "list nodes" unless env.empty?
      if health.length > 0
        puts health + "\n#{health.lines.count} platform offense(s) detected"
        false
      else
        true
      end
    end

    private

    def valid?(value, validate)
      puts "validate #{value} against #{validate}"
      case validate['type']
        when 'integer'
          rng = validate['range'].split('..').map{|d| Integer(d)}
          Range.new(rng[0],rng[1]).member?(value)
        when 'string'
          puts 'validate string'
          puts "test #{value} against #{validate['match']}"
          #puts "ok" if value=~Regexp.new(validate['match'])
        puts "#{validate['match'].match(value)}"


        when 'IP'
          Resolv::IPv4::Regex.match(value)
        else
          puts 'validate other'
      end
    end

    def platform_files_exist?
      fail(IOError, MISSING_PLATFORM) unless File.file?(PLATFORMFILE)
      @provider.definition['structure']['require'].each do |required_file|
        fail(IOError, MISSING_PLATFORM + required_file) unless File.file?(@provider.definition['structure'][required_file]['path'] + required_file + '.yml')
      end
      true
    end
  end
end